module YmContent::PersonasController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    if @persona.save
      redirect_to personas_path
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
    if @persona.update_attributes(params[:persona])
      redirect_to personas_path
    else
      render :action => 'edit'
    end
  end
  
end