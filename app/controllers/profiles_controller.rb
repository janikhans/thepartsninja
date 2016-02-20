class ProfilesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def update
    @user = current_user
    @profile = current_user.profile
      if @profile.update(profile_params)
        redirect_to dashboard_user_profile_path, notice: 'Profile was successfully updated.'
      else
        render 'dashboard/profile'
      end
  end

  private

    def profile_params
      params.require(:profile).permit(:user_id, :location, :bio)
    end
end
