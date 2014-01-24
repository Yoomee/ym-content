module YmContent::ContentType
  
  def self.included(base)
    base.has_many :content_attributes, :order => :position
    base.has_many :content_packages
    base.validates_presence_of :name
    base.accepts_nested_attributes_for :content_attributes, :allow_destroy => true
  end
  
end