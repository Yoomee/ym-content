module YmContent::ContentPackage
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :content_type
    base.has_many :content_chunks, :autosave => true
    base.belongs_to :parent, :class_name => "ContentPackage"
    base.has_many :children, :class_name => "ContentPackage", :foreign_key => 'parent_id'
    base.has_and_belongs_to_many :personas
    base.belongs_to :author, :class_name => 'User'
    base.belongs_to :requested_by, :class_name => 'User'

    base.before_create :set_next_review

    base.validates :name, :content_type, :requested_by, :review_frequency, :presence => true
    base.validate :required_attributes
    base.validate :embeddable_attributes

    base.delegate :content_attributes, :package_name, :view_name, :missing_view?, :viewless?, :to => :content_type

    base.has_permalinks

    base.alias_method_chain(:set_permalink_path, :viewless)

    base.extend(ClassMethods)

    base.scope :root, base.where(:parent_id => nil)
    base.scope :published, base.where(:status => 'published')
    base.scope :expiring, base.where('next_review < ?', Date.today)
  end

  module ClassMethods

    def statuses(user)
      Hash.new.tap do |s|
        s[:draft] = 'Draft'
        s[:pending] = 'Ready to review'
        s[:published] = 'Published' if user.is_admin? || user.try(:role_is?, :editor)
      end
    end

    def review_frequencies
      {
        :'1' => 'Monthly',
        :'2' => 'Every 2 Months',
        :'3' => 'Every 3 Months',
        :'6' => 'Every 6 Months'
      }
    end

  end

  def parents
    [parent, parent.try(:parents)].flatten.compact
  end

  def publicly_visible?
    status == 'published' && !missing_view?
  end

  def respond_to_with_content_attributes?(method_id, include_all = false)
    slug = method_id.to_s.sub(/^retained_/,'').sub(/^remove_/,'').sub(/_uid$/,'').chomp('=')
    respond_to_without_content_attributes?(method_id, include_all) || content_type && (content_attributes.exists?(:slug => slug) || content_attributes.exists?(:slug => slug.chomp('_url')))
  end
  alias_method_chain :respond_to?, :content_attributes

  def to_s
    name
  end

  private
  def embeddable_attributes
    self.content_chunks.each do |content_chunk|
      if content_chunk.content_attribute.field_type.embeddable? && content_chunk.value.present?
        begin
          content_chunk.html = OEmbed::Providers.get(content_chunk.value).html
        rescue OEmbed::NotFound => e
          content_chunk.html = nil
          self.errors.add(content_chunk.content_attribute.slug + '_url', "No embeddable content found at this URL")
        end
      end
    end
  end

  def get_value_for_content_attribute(content_attribute, method = nil)
    content_chunk = content_chunks.find_by_content_attribute_id(content_attribute.id)
    case content_attribute.field_type
    when 'file'
      content_chunk.try(:file)
    when 'link'
      instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.try(:value))
    when 'image'
      content_chunk.try(:image)
    when 'embeddable'
      if method == 'url'
        instance_variable_set("@#{content_attribute.slug}_url".to_sym, content_chunk.try(:value))
      else
        instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.try(:html).to_s.gsub('http://', 'https://').html_safe)
      end
    else
      instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.try(:value).try(:html_safe))
    end
  end

  def method_missing(method_sym, *arguments, &block)
    return super if method_sym.to_s =~ /[?]$/ # e.g. method? or method!
    attribute_name = method_sym.to_s.chomp('=')
    if !method_sym.to_s.end_with?('=') && instance_variable_defined?("@#{attribute_name}".to_sym)
      instance_variable_get("@#{attribute_name}".to_sym)
    elsif content_type
      if attribute_name =~ /^retained_(.*)/ || attribute_name =~ /^remove_(.*)/ || attribute_name =~ /(.*)_uid$/
        file_attribute_name = $1
        if content_attribute = content_attributes.find_by_slug(file_attribute_name)
          content_chunk = self.content_chunks.find_or_initialize_by_content_attribute_id(content_attribute.id)
          file_method_sym = method_sym.to_s.sub(file_attribute_name, content_attribute.field_type)
          if arguments.present?
            content_chunk.send(file_method_sym, arguments.first)
            content_chunk.save if method_sym.to_s.end_with?('=') # TODO shouldn't need to save here
          else
            content_chunk.send(file_method_sym)
          end
        else
          super
        end
      elsif content_attribute = content_attributes.find_by_slug(attribute_name)
        if method_sym.to_s.end_with?('=')
          set_value_for_content_attribute(content_attribute, arguments.first)
        else
          get_value_for_content_attribute(content_attribute)
        end
      elsif content_attribute = content_attributes.find_by_slug(attribute_name.chomp('_url'))
        if method_sym.to_s.end_with?('=')
          set_value_for_content_attribute(content_attribute, arguments.first, 'url')
        else
          get_value_for_content_attribute(content_attribute, 'url')
        end
      else
        super
      end
    else
      super
    end
  end

  def required_attributes
    return true if new_record? || content_type.nil?
    content_attributes.each do |content_attribute|
      if content_attribute.required? && send(content_attribute.slug).blank?
        self.errors.add_on_blank(content_attribute.slug)
      end
    end
  end

  def set_next_review
    self.next_review = Date.today + self.review_frequency.months
  end

  def set_permalink_path_with_viewless
    content_type.try(:viewless?) ? true : set_permalink_path_without_viewless
  end

  def set_value_for_content_attribute(content_attribute, value, method = nil)
    content_chunk = self.content_chunks.find_or_initialize_by_content_attribute_id(content_attribute.id)
    case content_attribute.field_type
    when 'file'
      content_chunk.file = value
    when 'image'
      content_chunk.image = value
    when 'link'
      content_chunk.value = value.to_s
    when 'embeddable'
      if method == 'url'
        content_chunk.value = value
      else
        content_chunk.html = html
      end
    else
      content_chunk.value = value
    end
    content_chunk.save unless new_record? # TODO shouldn't need to save here
    instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.value) unless %w{file image}.include?(content_attribute.field_type)
  end

end