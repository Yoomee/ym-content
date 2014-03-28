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
    if params[:open] && open_content_package = ContentPackage.find_by_id(params[:open])
      @open = [open_content_package] + open_content_package.parents
    end
    @content_types = ::ContentType.order(:name)
  end

  def new
    @content_package.content_type = ::ContentType.find_by_id(params[:content_type_id])
    @content_package.parent_id = params[:parent]
    @content_package.requested_by = current_user
    @content_package.review_frequency = 1
  end

  def reorder
  end

  def save_order
    params[:children_ids].each_with_index do |child_id, position|
      ContentPackage.find(child_id).update_attribute(:position, position)
    end
    redirect_to content_packages_path(:open => @content_package.id)
  end

  def search
    @results = ContentPackage.search(params[:q], :with => {:parent_id => @content_package.id}, :page => params[:page], :per_page => params[:per_page] || 20)
    render_content_package_view
  end

  def show
    render_content_package_view
  end

  def update
    if @content_package.update_attributes(params[:content_package])
      redirect_to @content_package
    else
      render :action => 'edit'
    end
  end

  private
  def render_content_package_view
    if template_exists?("content_packages/views/#{@content_package.view_name}")
      render "content_packages/views/#{@content_package.view_name}" and return
    end
  end

end