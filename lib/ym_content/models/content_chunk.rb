module YmContent::ContentChunk

  def self.included(base)
    base.belongs_to :content_package
    base.belongs_to :content_attribute
    base.send(:file_accessor, :file)
  end

  def file_uid
    read_attribute(:value)
  end

  def file_uid=(uid)
    self.value = uid
  end

  def value
    case content_attribute.field_type
    when 'file'
      file
    when 'image'
      file
    when 'link'
      YmContent::Link.new(read_attribute(:value))
    else
      read_attribute(:value)
    end
  end

end