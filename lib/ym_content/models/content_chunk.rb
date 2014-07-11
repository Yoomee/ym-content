module YmContent::ContentChunk

  def self.included(base)
    base.belongs_to :content_package
    base.belongs_to :content_attribute
    base.send(:file_accessor, :file)
    base.send(:geocoded_by, :value)
    base.send(:after_validation, :geocode_if_geocodeable)
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

  private
  def geocode_if_geocodeable
    if content_attribute
      if content_attribute.field_type == "location"
        do_lookup(false) do |o,rs|
          if r = rs.first
            self.html = r.coordinates.join(',')
          end
        end
      end
    end
  end

end
