module YmContent::ContentPackage
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :content_type
    base.has_many :content_chunks, :autosave => true
    base.belongs_to :parent, :class_name => "ContentPackage"
    base.has_many :children, :class_name => "ContentPackage", :foreign_key => 'parent_id'
    base.has_and_belongs_to_many :personas
    base.belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

    base.validates :content_type, :presence => true
    # base.validate :required_attributes

    base.delegate :content_attributes, :package_name, :view_name, :to => :content_type

    base.has_permalinks

    base.send(:attr_accessor, :author)

    base.extend(ClassMethods)

    base.scope :root, base.where(:parent_id => nil)
  end

  module ClassMethods

    def statuses
      {
        :draft => 'Draft',
        :pending => 'Ready to review',
        :published => 'Published'
      }
    end

  end

  def parents
    [parent, parent.try(:parents)].flatten.compact
  end

  def respond_to_with_content_attributes?(method_id, include_all = false)
    respond_to_without_content_attributes?(method_id, include_all) || content_type && content_attributes.exists?(:slug => method_id.to_s.chomp('='))
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
    elsif content_type && content_attribute = content_attributes.find_by_slug(attribute_name)
      if method_sym.to_s.end_with?('=')
        content_chunk = self.content_chunks.find_or_initialize_by_content_attribute_id(content_attribute.id)
        content_chunk.value = arguments.first
        content_chunk.save # TODO shouldn't need to save here
        instance_variable_set("@#{attribute_name}".to_sym, arguments.first)
      else
        instance_variable_set("@#{attribute_name}".to_sym, content_chunks.find_by_content_attribute_id(content_attribute.id).try(:value))
      end
    else
      super
    end
  end

  def required_attributes
    return true unless content_type
    content_attributes.each do |content_attribute|
      if content_attribute.required? && send(content_attribute.slug).blank?
        self.errors.add_on_blank(content_attribute.slug)
      end
    end
  end

end