module YmContent::ContentAttribute
  
  def self.included(base)
    base.belongs_to :content_type
    base.validates :slug, :name, :field_type, :presence => true
  end
  
end