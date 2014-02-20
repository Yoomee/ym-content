module YmContent::ContentChunk

  def self.included(base)
    base.belongs_to :content_package
    base.belongs_to :content_attribute
    base.send(:file_accessor, :file)
    base.send(:alias_attribute, :file_uid, :value)
    base.send(:image_accessor, :image)
    base.send(:alias_attribute, :image_uid, :value)
  end

end