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

    base.validates :content_type, :requested_by, :review_frequency, :presence => true
    base.validate :required_attributes

    base.delegate :content_attributes, :package_name, :view_name, :to => :content_type

    base.has_permalinks

    base.extend(ClassMethods)

    base.scope :root, base.where(:parent_id => nil)
    base.scope :published, base.where(:status => 'published')
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

  def respond_to_with_content_attributes?(method_id, include_all = false)
    slug = method_id.to_s.sub(/^retained_/,'').sub(/^remove_/,'').sub(/_uid$/,'').chomp('=')
    respond_to_without_content_attributes?(method_id, include_all) || content_type && content_attributes.exists?(:slug => slug)
  end
  alias_method_chain :respond_to?, :content_attributes

  def to_s
    ((respond_to?(:title) ? title.presence : nil) || slug).to_s
  end

  private
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
          content_chunk = self.content_chunks.find_or_initialize_by_content_attribute_id(content_attribute.id)
          case content_attribute.field_type
          when 'file'
            content_chunk.file = arguments.first
          when 'image'
            content_chunk.image = arguments.first
          else
            content_chunk.value = arguments.first
          end
          content_chunk.save # TODO shouldn't need to save here
          instance_variable_set("@#{attribute_name}".to_sym, arguments.first) unless %w{file image}.include?(content_attribute.field_type)
        else
          content_chunk = content_chunks.find_by_content_attribute_id(content_attribute.id)
          case content_attribute.field_type
          when 'file'
            content_chunk.try(:file)
          when 'image'
            content_chunk.try(:image)
          else
            instance_variable_set("@#{attribute_name}".to_sym, content_chunk.try(:value))
          end
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

end