module YmContent::ContentPackagesController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def activity
    if request.xhr?
      page = params[:page] || 2
      if @content_package
        @activity_items = @content_package.paginate(:page => page, :per_page => 5)
      else
        @activity_items = ActivityItem.where(:resource_type => "ContentPackage").paginate(:page => page, :per_page => 5)
      end
      @page = page.to_i + 1
    end
  end

  def children
  end

  def create
    if @content_package.save
      current_user.record_activity!(@content_package, :text => "created")
      redirect_to edit_content_package_path(@content_package)
    else
      render :action => 'new'
    end
  end

  def deleted
    @deleted_content_packages = ContentPackage.where("deleted_at IS NOT NULL").order("deleted_at DESC").paginate(:page => params[:page], :per_page => 50)
  end

  def destroy
    if @content_package.delete
      flash[:notice] = "Deleted \"#{@content_package}\" - #{view_context.link_to('Undo', restore_content_package_path(@content_package), :method => :put)}"
    else
      flash[:error] = "\"#{@content_package}\" couldn't be deleted"
    end
    redirect_to content_packages_path(:open => @content_package.parent)
  end

  def index
    @content_packages = @content_packages.root.includes(:children)
    if params[:open] && open_content_package = ContentPackage.find_by_id(params[:open])
      @open = [open_content_package] + open_content_package.parents
    end
  end

  def new
    @content_package.content_type = ::ContentType.find_by_id(params[:content_type_id])
    @content_package.parent_id = params[:parent]
    @content_package.requested_by = current_user
    @content_package.review_frequency = 1
  end

  def reorder
  end

  def restore
    @content_package.restore
    flash[:notice] = "Restored \"#{@content_package}\""
    redirect_to content_packages_path(:open => @content_package)
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
    if @content_package.update_attributes(content_package_params)
      current_user.record_activity!(@content_package, :text => "updated")
      redirect_to @content_package
    else
      render :action => 'edit'
    end
  end

  private
    def content_package_params
      params.require(:content_package).permit(*params[:content_package].try(:keys))
    end


  def render_content_package_view
    if template_exists?("content_packages/views/#{@content_package.view_name}")
      render "content_packages/views/#{@content_package.view_name}" and return
    end
  end

end
