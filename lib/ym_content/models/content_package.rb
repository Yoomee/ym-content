module YmContent::ContentPackage
  
  def self.included(base)
    base.send(:include, YmCore::Model)

    base.belongs_to :content_type
    base.has_many :content_chunks, :autosave => true
    base.belongs_to :parent, :class_name => "ContentPackage"
    base.has_many :children, :class_name => "ContentPackage", :foreign_key => 'parent_id'
    base.has_and_belongs_to_many :personas

    base.validates :content_type, :presence => true

    base.delegate :content_attributes, :to => :content_type

    base.has_permalinks

    base.delegate :package_name, :to => :content_type

  end

  def respond_to?(method_id, include_all = false)
    super || content_type && content_attributes.exists?(:slug => method_id.to_s.chomp('='))
  end

  def to_s
    ((respond_to?(:title) ? title.presence : nil) || slug).to_s
  end

  private
  def method_missing(method_sym, *arguments, &block)
    return super if method_sym.to_s =~ /[?]$/ # e.g. method? or method!
    attribute_name = method_sym.to_s.chomp('=')
    if !method_sym.to_s.end_with?('=') && instance_variable_defined?("@#{attribute_name}".to_sym)
      instance_variable_get("@#{attribute_name}".to_sym)
    elsif content_attribute = content_attributes.find_by_slug(attribute_name)
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

end