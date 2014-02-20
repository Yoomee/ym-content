module YmContent::ContentAttribute
  
  def self.included(base)
    base.belongs_to :content_type
    base.after_validation :set_slug
    base.validates :slug, :name, :field_type, :presence => true
    base.validates :slug, :name, :uniqueness => { :scope => :content_type_id }
  end

  def input_type
    case field_type
    when 'file' then 'file_with_preview'
    when 'text' then 'redactor'
    else field_type
    end
  end

  private
  def set_slug
    if slug.blank? && name.present? && errors['name'].blank?
      slug_name = name.parameterize("_")
      if ::ContentPackage.new().respond_to_without_content_attributes?(slug_name,true)
        slug_name = 'content_package_' + slug_name
      end
      self.slug = slug_name
      valid?
    end
  end

end