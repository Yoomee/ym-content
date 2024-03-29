module YmContent::PersonasController

  def self.included(base)
    base.layout 'ym_content/application'
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
    @persona_groups = ::PersonaGroup.order(:position, :name)
  end

  def new
  end

  def update
    if @persona.update_attributes(persona_params)
      redirect_to personas_path
    else
      render :action => 'edit'
    end
  end

  private
  def persona_params
    params.require(:persona).permit(:name, :age, :category, :summary, :benefit_1, :benefit_2, :benefit_3, :benefit_4, :image, :retained_image, :image_uid, :file, :retained_file, :file_uid, :group_id, :group_name)
  end
end
