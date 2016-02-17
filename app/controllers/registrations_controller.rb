class RegistrationsController < Devise::RegistrationsController
  layout "dashboard", only: [:new, :update]
  protected

    def after_update_path_for(resource)
      dashboard_account_settings_path
    end
end
