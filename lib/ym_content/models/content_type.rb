module YmContent::ContentType

  def self.included(base)
    base.has_many :content_attributes, :order => :position
    base.has_many :content_packages
    base.validates_presence_of :name
    base.accepts_nested_attributes_for :content_attributes, :allow_destroy => true
    base.extend(ClassMethods)
  end

  module ClassMethods

    def field_types
      {
        :string => 'Text',
        :text => 'Text area',
        :image => 'Image',
        :file => 'File'
      }
    end

  end

  def package_name
    read_attribute(:package_name).presence || name.downcase
  end

end