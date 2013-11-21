module YmContent::ContentChunk
  
  def self.included(base)
    base.belongs_to :content_package
    base.belongs_to :content_attribute
  end
  
end