module YmContent::ContentTypesController
  
  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    if @content_type.save
      redirect_to content_packages_path
    else
      render :action => 'edit'
    end
  end

  def edit
  end

  def index
  end

  def new
    @content_type.content_attributes.build
  end

  def update
    if @content_type.update_attributes(params[:content_type])
      redirect_to content_packages_path
    else
      render :action => 'edit'
    end
  end
  
end