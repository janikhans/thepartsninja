class Account::SettingsController < Account::ApplicationController
  def index
    @user = current_user
  end
end
