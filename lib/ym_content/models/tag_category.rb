module YmContent::TagCategory
  def self.included(base)
    base.acts_as_taggable_on :taxonomy
    base.acts_as_tagger
    base.has_many :resource_tag_categories
    base.has_many :content_types, :through => :resource_tag_categories, :source => :taggable_resource, :source_type => 'ContentType'
  end
end
