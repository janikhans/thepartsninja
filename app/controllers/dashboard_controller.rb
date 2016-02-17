class DashboardController < ApplicationController
  layout "dashboard"
  before_action :set_user
  before_action :authenticate_user!

  def activity
  end

  def profile
  end

  def settings
  end

  private

  def set_user
    @user = current_user
  end
end
