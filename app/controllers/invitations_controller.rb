class InvitationsController < Devise::InvitationsController
  layout "admin_dashboard", only: [:new, :create]
  include Admin
  before_action :admin_only, except: [:edit, :update]

  def after_invite_path_for(resource)
    admin_users_path
  end

end
