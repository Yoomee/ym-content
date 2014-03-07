module YmContent::ContentPackagesController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def children
  end

  def create
    if @content_package.save
      redirect_to edit_content_package_path(@content_package)
    else
      render :action => 'new'
    end
  end

  def index
    @content_packages = @content_packages.root.includes(:children)
    @content_types = ::ContentType.order(:name)
  end

  def new
    @content_package.content_type = ::ContentType.find_by_id(params[:content_type_id])
    @content_package.parent_id = params[:parent]
    @content_package.requested_by = current_user
    @content_package.review_frequency = 1
  end

  def show
    if template_exists?("content_packages/views/#{@content_package.view_name}")
      render "content_packages/views/#{@content_package.view_name}" and return
    end
  end

  def update
    if @content_package.update_attributes(params[:content_package])
      redirect_to @content_package
    else
      render :action => 'edit'
    end
  end

end