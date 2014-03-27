module YmContent::ContentPackage
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :content_type
    base.has_many :content_chunks
    base.belongs_to :parent, :class_name => "ContentPackage"
    base.has_many :children, :class_name => "ContentPackage", :foreign_key => 'parent_id'
    base.has_and_belongs_to_many :personas
    base.belongs_to :author, :class_name => 'User'
    base.belongs_to :requested_by, :class_name => 'User'

    base.before_create :set_next_review
    base.after_save :save_content_chunks

    base.validates :name, :content_type, :requested_by, :review_frequency, :presence => true
    base.validate :required_attributes
    base.validate :embeddable_attributes

    base.delegate :content_attributes, :package_name, :view_name, :missing_view?, :viewless?, :to => :content_type

    base.has_permalinks

    base.acts_as_taggable_on :acts_as_taggable_on_tags

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

  def content_chunks
    @content_chunks ||= super.to_a
  end

  def parents
    [parent, parent.try(:parents)].flatten.compact
  end

  def publicly_visible?
    status == 'published' && !missing_view?
  end

  def respond_to_with_content_attributes?(method_id, include_all = false)
    slug = method_id.to_s.sub(/^retained_/,'').sub(/^remove_/,'').sub(/_uid$/,'').chomp('=')
    respond_to_without_content_attributes?(method_id, include_all) || content_type && (content_attributes.exists?(:slug => slug) || content_attributes.exists?(:slug => slug.chomp('_list').pluralize) || content_attributes.exists?(:slug => slug.chomp('_url')))
  end
  alias_method_chain :respond_to?, :content_attributes

  def to_s
    name
  end

  private

  def content_chunk_for_content_attribute(content_attribute, initialise_if_nil = false)
    content_chunk = self.content_chunks.select{|c| c.content_attribute_id == content_attribute.id }.first
    if content_chunk.nil? && initialise_if_nil
      content_chunk = ContentChunk.new(:content_attribute => content_attribute, :content_package => self)
      self.content_chunks << content_chunk
    end
    content_chunk
  end

  def embeddable_attributes
    self.content_chunks.each do |content_chunk|
      if content_chunk.content_attribute.field_type.embeddable? && content_chunk.value_changed?
        if content_chunk.value.blank?
          content_chunk.value = nil
          content_chunk.html = nil
        else
          begin
            content_chunk.html = OEmbed::Providers.get(content_chunk.value).html
          rescue OEmbed::NotFound => e
            content_chunk.html = nil
            self.errors.add(content_chunk.content_attribute.slug + '_url', "No embeddable content found at this URL")
          end
        end
      end
    end
  end

  def find_file_attribute_name(attribute_name)
    regexes = Regexp.union(/^retained_(.*)$/, /^remove_(.*)$/, /^(.*)_uid$/)
    attribute_name.scan(regexes).flatten.compact.first
  end

  def find_tags_attribute_name(attribute_name)
    regexes = Regexp.union(/^(.*)_list$/, /^(.*)_taggings$/)
    attribute_name.scan(regexes).flatten.compact.first || attribute_name # Default to attribute_name in order to fetch e.g. 'skills'
  end

  def get_value_for_content_attribute(content_attribute, method = nil)
    content_chunk = content_chunk_for_content_attribute(content_attribute)
    case content_attribute.field_type
    when 'boolean'
      instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.try(:value) || false)
    when 'file', 'image'
      content_chunk.try(:file)
    when 'link'
      instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.try(:value))
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
    attribute_name = method_sym.to_s.chomp('=').chomp('?')
    if !method_sym.to_s.end_with?('=') && instance_variable_defined?("@#{attribute_name}".to_sym)
      instance_variable_get("@#{attribute_name}".to_sym)
    elsif content_type
      if (file_attribute_name = find_file_attribute_name(attribute_name)) && (content_attribute = content_attributes.where(:field_type => %w{image file}).find_by_slug(file_attribute_name))
        content_chunk = content_chunk_for_content_attribute(content_attribute, true)
        file_method_sym = method_sym.to_s.sub(file_attribute_name, 'file')
        if arguments.present?
          content_chunk.send(file_method_sym, arguments.first)
        else
          content_chunk.send(file_method_sym)
        end
      elsif (tags_attribute_name = find_tags_attribute_name(attribute_name)) && (content_attribute = content_attributes.where(:field_type => 'tags').find_by_slug(tags_attribute_name.pluralize))
        tags_context = tags_attribute_name.pluralize
        tag_context = tags_attribute_name.singularize
        case method_sym.to_s
        when "#{tag_context}_list"
           tag_list_on(tags_context)
        when "#{tag_context}_list="
          set_tag_list_on(tags_context, arguments.first)
        when "#{tags_context}_taggings"
          taggings.where("#{ActsAsTaggableOn::Tagging.table_name}.context = ?", tags_context)
        when tags_context
          ActsAsTaggableOn::Tag.joins(:taggings).where("#{ActsAsTaggableOn::Tagging.table_name}.taggable_id = ? AND #{ActsAsTaggableOn::Tagging.table_name}.taggable_type = 'ContentPackage' AND #{ActsAsTaggableOn::Tagging.table_name}.context = ?", id, tags_context)
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

  def save_content_chunks
    content_chunks.each(&:save)
  end

  def set_next_review
    self.next_review = Date.today + self.review_frequency.months
  end

  def set_permalink_path_with_viewless
    content_type.try(:viewless?) ? true : set_permalink_path_without_viewless
  end

  def set_value_for_content_attribute(content_attribute, value, method = nil)
    content_chunk = content_chunk_for_content_attribute(content_attribute, true)
    case content_attribute.field_type
    when 'boolean'
      content_chunk.value = [0, "0", false, "false", "", nil].include?(value) ? '0' : '1'
    when 'file', 'image'
      content_chunk.file = value
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
    instance_variable_set("@#{content_attribute.slug}".to_sym, content_chunk.value) unless %w{file image}.include?(content_attribute.field_type)
  end

end