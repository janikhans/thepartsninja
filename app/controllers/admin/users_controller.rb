class Admin::UsersController < Admin::DashboardController
  before_action :set_user, only: [:show, :destroy, :edit, :update]


  def index
    @users = User.page(params[:page]).order('created_at DESC')
  end

  def show
  end

  def edit
  end

  def update
    if params[:user]['password'].blank?
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully destroyed.'
  end

  private
    # FIXME we shouldn't need to use User.friendly here. Friendly_id :finders should pick these up.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :username, :role, :password, :password_confirmation, :invitation_limit, profile_attributes: [:id, :bio, :location])
    end
 end
