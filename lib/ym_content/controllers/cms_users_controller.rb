module YmContent::CmsUsersController

  def self.included(base)
    base.authorize_resource :user
  end

  def set_active
    @user.active = !@user.active
    @show_inactive = session[:show_inactive] || false
  end

  def manage
    @show_inactive = (params[:show_inactive] && params[:show_inactive] == "true") || false
    if @show_inactive
      @users = User.cms_users.all
    else
      @users = User.cms_users.where(active: true)
    end
    @users = @users.order_by_last_name
    session[:show_inactive] = @show_inactive
  end

  def destroy
    @user_id = @user.id
    @user.destroy
    flash_notice(@user)
  end

  private
  def permitted_user_parameters
    permitted_params = %w(bio email first_name image last_name remove_image retained_image)
    permitted_params << 'role' if current_user.admin?
    permitted_params
  end
end
