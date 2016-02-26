module Admin
  extend ActiveSupport::Concern

    def admin_only
      unless current_user.try(:admin?)
        redirect_to dashboard_path, alert: 'Access Denied'
      end
    end

end
