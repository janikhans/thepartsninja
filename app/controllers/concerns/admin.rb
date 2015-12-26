module Admin
  extend ActiveSupport::Concern

    def admin_only
      unless current_user.admin?
        redirect_to root_path
      end
    end


end