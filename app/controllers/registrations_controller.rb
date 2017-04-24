class RegistrationsController < Devise::RegistrationsController
  before_action :production_redirect, only: [:new, :create]
  layout 'devise'
  layout 'account/application', only: [:edit, :update]

  protected

  def production_redirect
    if Rails.env.production?
      flash[:notice] = 'Registration is not open yet, please check back soon'
      redirect_to root_path
    end
  end

  def after_update_path_for(*)
    account_settings_path
  end
end
