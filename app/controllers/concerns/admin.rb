module Admin
  extend ActiveSupport::Concern

    def admin_only
      unless current_user.try(:admin?)
        redirect_to login_path, alert: 'You must be logged in for access'
      end
    end


end
