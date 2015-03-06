module YmContent::TagsController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def index
    @tag_categories = ::TagCategory.all
  end

end
