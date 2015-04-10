module YmContent::CmsUsersController

  def self.included(base)
    base.layout 'ym_content/application'
    base.authorize_resource :cms_user
    if Rails::VERSION::MAJOR >= 4
      base.before_action :check_cms_user, except: [:index, :new, :create_user]
    else
      base.before_filter :check_cms_user, except: [:index, :new, :create_user]
    end
  end

  def check_cms_user
    @user = CmsUser.find(params[:id])
    unless CmsUser.available_roles.include? @user.role
      raise ActiveRecord::RecordNotFound
    end 
  end

  def set_active
    @user.update(active: !@user.active)
    @show_inactive = session[:show_inactive] || false
  end

  def index
    @show_inactive = (params[:show_inactive] && params[:show_inactive] == "true") || false
    if @show_inactive
      @users = CmsUser.all_users
    else
      @users = CmsUser.all_users.where(active: true)
    end
    @users = @users.order('LOWER(last_name)')
    session[:show_inactive] = @show_inactive
  end

  def destroy
    # Cast back to user so we don't break all the callbacks
    @user = User.find(@user.id)
    @user_id = @user.id
    @user.destroy
  end

  def show
    @assigned_content = ContentPackage.where(author_id: @user.id)
  end

  def edit
  end

  def update
    if @user.update_attributes(create_user_params)
      return_or_redirect_to(@user)
    else
      render :action => "edit"
    end
  end

  def create_user
    # Admins need to be able to sign people up, can't use create route because it signs you in
    @user = CmsUser.new(create_user_params)
    if @user.save
      redirect_to(cms_user_path(@user))
    else
      render :action => "new"
    end
  end

  def new
    @user = CmsUser.new
  end

  private

  def create_user_params
    params.require(:cms_user).permit(permitted_user_parameters.push(:role, :password))
  end

  def permitted_user_parameters
    permitted_params = %w(bio email first_name image last_name remove_image retained_image)
    permitted_params << 'role' if current_user.admin?
    permitted_params
  end
end
