module YmContent::ContentPackagesController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    if @content_package.save
      redirect_to edit_content_package_path(@content_package)
    else
      render :action => 'edit'
    end
  end

  def index
    @content_types = ContentType.order(:name)
  end

  def new
    @content_package.content_type = ContentType.find_by_id(params[:content_type_id])
  end

  def show
  end

  def update
    if @content_package.update_attributes(params[:content_package])
      redirect_to @content_package
    else
      render :action => 'edit'
    end
  end

end