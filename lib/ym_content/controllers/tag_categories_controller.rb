module YmContent::TagCategoriesController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def new
  end

  def create
    if @tag_category.save
      redirect_to tags_path
    else
      render :new, error: "Sorry there was a problem saving this category: #{@tag_category.errors.full_messages.to_sentence}"
    end
  end

  def edit
  end

  private

  def tag_category_params
     params.require(:tag_category).permit(:name, :slug)
  end

end
