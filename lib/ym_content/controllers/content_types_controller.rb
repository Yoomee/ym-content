module YmContent::ContentTypesController
  
  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    if @content_type.save
      redirect_to content_types_path
    else
      render :action => 'edit'
    end
  end

  def edit
  end

  def index
  end

  def new
  end

  def update
    if @content_type.update_attributes(params[:content_type])
      redirect_to content_types_path
    else
      render :action => 'edit'
    end
  end
  
end