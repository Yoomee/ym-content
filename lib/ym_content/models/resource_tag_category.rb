module YmContent::ResourceTagCategory
  def self.included(base)
    base.belongs_to :tag_category
    base.belongs_to :taggable_resource, :polymorphic => true
  end
end