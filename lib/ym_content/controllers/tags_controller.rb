module YmContent::TagsController

  def self.included(base)
    base.layout 'ym_content/application'
    base.load_and_authorize_resource
  end

  def index
    @tag_categories = ::TagCategory.all
  end

end
