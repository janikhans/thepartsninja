class Account::ProfileController < Account::ApplicationController
  def edit
    @user = current_user
    @profile = @user.profile
  end

  def update
    @user = current_user
    @profile = current_user.profile
    if @profile.update(profile_params)
      redirect_to edit_account_profile_index_path, notice: 'Profile was successfully updated.'
    else
      render 'edit'
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:user_id, :location, :bio)
    end
end
