module YmContent::ContentTypesController
  
  def self.included(base)
    base.load_and_authorize_resource
  end
  
  def edit
  end

  def index
  end
  
  def update
    @content_type.update_attributes(params[:content_type])
    render :action => :edit
  end
  
end