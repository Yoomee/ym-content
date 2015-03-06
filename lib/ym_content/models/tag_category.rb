module YmContent::TagCategory
  def self.included(base)
    base.acts_as_ordered_taggable_on :taxonomy
    base.acts_as_tagger
    base.has_many :resource_tag_categories
    base.has_many :content_types, :through => :resource_tag_categories, :source => :taggable_resource, :source_type => 'ContentType'
  end

  def tag_count_for(tag)
    ActsAsTaggableOn::Tagging.where(tag: tag, tagger: self).count
  end

end
