module YmContent::ContentAttribute
  
  def self.included(base)
    base.belongs_to :content_type
    base.after_validation :set_slug
    base.validates :content_type, :slug, :name, :field_type, :presence => true
    base.validates :slug, :name, :uniqueness => { :scope => :content_type_id }
  end

  private
  def set_slug
    if slug.blank? && name.present? && errors['name'].blank?
      self.slug = name.to_url.parameterize
      valid?
    end
  end

end