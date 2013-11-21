module YmContent::ContentPackage
  
  def self.included(base)
    base.send(:include, YmCore::Model)
    
    base.belongs_to :content_type
    base.has_many :content_chunks, :autosave => true
    base.belongs_to :parent, :class_name => "ContentPackage"
    base.has_many :children, :class_name => "ContentPackage", :foreign_key => 'parent_id'
    
    base.delegate :content_attributes, :to => :content_type
  end
  
  private
  def method_missing(method_sym, *arguments, &block)
    attribute_name = method_sym.to_s.chomp('=')
    if instance_variable_defined?("@#{attribute_name}")
      instance_variable_get("@#{attribute_name}")
    elsif content_attribute = content_attributes.find_by_slug(attribute_name)
      if method_sym.to_s.end_with?('=')
        content_chunk = self.content_chunks.find_or_initialize_by_content_attribute_id(content_attribute.id)
        content_chunk.value = arguments.first
        instance_variable_set("@#{attribute_name}", arguments.first)
      else
        instance_variable_set("@#{attribute_name}", content_chunks.find_by_content_attribute_id(content_attribute.id).try(:value))
      end
    else
      super
    end
  end
  
end