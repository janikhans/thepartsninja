class RegistrationsController < Devise::RegistrationsController
  layout 'devise'
  layout 'account/application', only: [:edit, :update]

  protected

  def after_update_path_for(*)
    account_settings_path
  end
end
