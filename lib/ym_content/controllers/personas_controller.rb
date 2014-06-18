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
    @persona_groups = PersonaGroup.order(:position, :name)
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

  private
  def persona_params
    params.require(:persona).permit(:name, :age, :summary, :benefit_1, :benefit_2, :benefit_3, :benefit_4, :image_uid, :file_uid, :group_id)
  end
end