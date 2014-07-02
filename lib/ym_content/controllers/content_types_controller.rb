module YmContent::ContentTypesController
  
  def self.included(base)
    base.load_and_authorize_resource
  end

  def children
  end

  def create
    if @content_type.save
      redirect_to content_packages_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @content_type.destroy
      flash[:notice] = "The content type was successfully deleted"
    else
      flash[:error] = "Unable to delete this content type"
    end
    redirect_to content_packages_path(:anchor => 'content-types')
  end

  def dashboard
    @activity_items = ActivityItem.where(:resource_type => "ContentPackage").paginate(:page => 1, :per_page => 5)
  end

  def edit
    @content_type.content_attributes.build if @content_type.content_attributes.count.zero?
  end

  def index
    @content_types = ::ContentType.order(:name)
  end

  def new
    @content_type.content_attributes.build
  end

  def reorder
  end

  def save_order
    params[:content_attribute_ids].each_with_index do |content_attribute_id, position|
      ContentAttribute.find(content_attribute_id).update_attribute(:position, position)
    end
    redirect_to content_packages_path(:anchor => 'content-types')
  end

  def update
    if @content_type.update_attributes(content_type_params)
      redirect_to content_packages_path
    else
      render :action => 'edit'
    end
  end

  private
  def content_type_params
    params.require(:content_type).permit(:id, :name, :description, :singleton, :package_name, :viewless, :view_name, :use_workflow, :content_attributes_attributes => [:id, :name, :description, :field_type, :required, :meta, :meta_tag_name, :_destroy])
  end
end