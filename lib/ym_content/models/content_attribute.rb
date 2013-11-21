module YmContent::ContentAttribute
  
  def self.included(base)
    base.belongs_to :content_type
  end
  
end