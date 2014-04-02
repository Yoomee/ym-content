module YmContent::ContentChunk

  def self.included(base)
    base.belongs_to :content_package
    base.belongs_to :content_attribute
    base.send(:file_accessor, :file)
  end

  def dragonfly_attachments
    if %{file image}.include?(content_attribute.try(:field_type).to_s)
      super
    else
      {}
    end
  end

  def file_uid
    read_attribute(:value)
  end

  def file_uid=(uid)
    self.value = uid
  end

  def raw_value
    read_attribute(:value)
  end

  def value
    case content_attribute.field_type
    when 'boolean'
      raw_value == '1'
    when 'file'
      file
    when 'image'
      file
    when 'link'
      YmContent::Link.new(raw_value)
    when 'user'
      User.find_by_id(raw_value) if raw_value.present?
    else
      raw_value
    end
  end

end
