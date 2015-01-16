module YmContent::ContentTypesController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def children
  end

  def create
    if @content_type.save
      redirect_to content_types_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @content_type.destroy
      flash[:notice] = "The content template was successfully deleted"
    else
      flash[:error] = "Unable to delete this content template"
    end
    redirect_to content_packages_path(:anchor => 'content-types')
  end

  def dashboard
    @activity_items = ActivityItem.where(:resource_type => "ContentPackage").paginate(:page => 1, :per_page => 5)
    @my_content = ContentPackage.where(:author_id => current_user.try(:id)).order('due_date, id')
  end

  def duplicate
    seed = @content_type
    if params[:to]
      @content_type = ContentType.find(params[:to])
    else
      @content_type = ContentType.new
    end
    first_position = @content_type.content_attributes.size
    seed.content_attributes.each_with_index do |content_attribute, idx|
      @content_type.content_attributes.build(content_attribute.attributes.slice(*ContentAttribute.fields_to_duplicate).merge(:position => first_position + idx))
    end
    render :action => @content_type.new_record? ? 'new' : 'edit'
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
    params.require(:content_type).permit(
      :name,
      :description,
      :singleton,
      :package_name,
      :viewless,
      :view_name,
      :use_workflow,
      :content_attributes_attributes => [
        :id,
        :_destroy,
        :default_attribute_id,
        :name,
        :description,
        :field_type,
        :required,
        :meta,
        :meta_tag_name,
        :limit_quantity,
        :limit_unit,
        :position,
        :num_text_blocks,
        :num_heading_blocks,
        :num_list_blocks,
        :num_quote_blocks,
        :num_image_blocks,
        :num_video_blocks,
      ]
    )
  end
end
