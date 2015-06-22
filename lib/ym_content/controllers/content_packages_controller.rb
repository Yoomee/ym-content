module YmContent::ContentPackagesController

  def self.included(base)
    base.load_and_authorize_resource

    # Define an around filter for all controller actions that could potenatially be
    # routed to from a permalinks
    if Rails::VERSION::MAJOR >= 4
      base.around_action :redirect_to_permalink, :only => ContentPackage.member_routes.collect{ |x| x[:action] }
    else
      base.around_filter :redirect_to_permalink, :only => ContentPackage.member_routes.collect{ |x| x[:action] }
    end
  end

  def activity
    if request.xhr?
      page = params[:page] || 2
      if @content_package
        @activity_items = @content_package.activity_items.paginate(:page => page, :per_page => 5)
      else
        @activity_items = ActivityItem.where(:resource_type => "ContentPackage").paginate(:page => page, :per_page => 5)
      end
      @page = page.to_i + 1
    end
  end

  def children
  end

  def edit
    get_view_data
  end

  def create
    if @content_package.save
      current_user.record_activity!(@content_package, :text => "created")
      redirect_to edit_content_package_path(@content_package)
    else
      render :action => 'new'
    end
  end

  def delete
    if @content_package.delete
      flash[:notice] = "Deleted \"#{@content_package}\" - #{view_context.link_to('Undo', restore_content_package_path(@content_package), :method => :put)}"
    else
      flash[:error] = "\"#{@content_package}\" couldn't be deleted"
    end
    redirect_to content_packages_path(:open => @content_package.parent)
  end

  def deleted
    @deleted_content_packages = ContentPackage.where("deleted_at IS NOT NULL").order("deleted_at DESC").paginate(:page => params[:page], :per_page => 50)
  end

  def destroy
    if @content_package.destroy
      flash[:notice] = "Destroyed \"#{@content_package}\""
    else
      flash[:error] = "\"#{@content_package}\" couldn't be destroyed"
    end
    redirect_to deleted_content_packages_path
  end

  def index
    @content_packages = @content_packages.root.includes(:children)
    if params[:open] && open_content_package = ContentPackage.find_by_id(params[:open])
      @open = [open_content_package] + open_content_package.parents
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @content_package.content_type = ::ContentType.find_by_id(params[:content_type_id])
    @content_package.parent_id = params[:parent]
    @content_package.requested_by = current_user
    @content_package.review_frequency = 1
    @content_package.due_date = Date.today
    @content_types = ContentType.all
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
    # @content_package = ContentPackage.includes(:content_chunks => :content_attribute).find(params[:id])
    render_content_package_view
  end

  def update
    get_view_data
    previous_status = @content_package.status
    if @content_package.update_attributes(content_package_params)
      flash[:notice] = "Updated \"#{@content_package}\""
      current_user.record_activity!(@content_package, :text => "updated")
      if @content_package.status == 'published' && previous_status != 'published'
        @content_package.published_at = @content_package.publish_at.presence || DateTime.now
        @content_package.save
      end
      if @content_package.status != 'published' && previous_status == 'published'
        @content_package.update_attributes(published_at: nil, publish_at: nil)
      end
      if @content_package.missing_view?
        redirect_to content_packages_path(:open => @content_package)
      else
        redirect_to @content_package
      end
    else
      #TODO change to flash[:error] when the style has been made
      flash[:notice] = "Sorry there was a problem saving this page: #{@content_package.errors.full_messages.to_sentence}"
      render :action => 'edit'
    end
  end

  private
  def content_package_params
    params.require(:content_package).permit(*params[:content_package].try(:keys) + [:persona_ids => []])
  end

  def get_view_data
      # added double colon to access global scope... #TODO: this needs reviewing
      @persona_groups = ::PersonaGroup.all
      @activity_items = @content_package.activity_items.includes(:user, :resource).paginate(:page => 1, :per_page => 5)
      @non_meta_content_attributes = @content_package.content_attributes.where(:meta => false)
      @meta_content_attributes = @content_package.content_attributes.where(:meta => true)
    end

    def render_content_package_view
      if template_exists?("content_packages/views/#{@content_package.view_name}")
        render "content_packages/views/#{@content_package.view_name}" and return
      end
    end

    def redirect_to_permalink
      # If the url matched a permalinkable content package route then it will have a param of :path
      if params[:path]
        if permalink = Permalink.find_from_url(params[:path])
          #If the permalink is active then just set the content package and yield to the original action.
          if permalink.active
            @content_package = ContentPackage.includes(:content_chunks => :content_attribute).find(permalink.resource_id)
            authorize! params[:action].to_sym, @content_package
            yield
          else
            # Otherwise redirect to the proper permalink so that we come back to this method and fall through the correct path.
            redirect_to permalink.resource.permalink.full_path + params_for_redirect, status: 301
          end
        else
          # If there isn't a matching permalink handle it with rails (Default is 404)
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        if (@content_package && @content_package.permalink.nil?) || ContentPackage.member_routes.reject { |x| x[:action] == "show" }.any?{|x| x[:action] == params[:action]}
          yield
        else
          redirect_to @content_package.permalink.full_path + params_for_redirect, status: 301
        end
      end
    end

    private

    def params_for_redirect
      significant_params = params.except(:action, :controller, :id, :path)
      significant_params.present? ? '?' + significant_params.to_query : ''
    end

end
