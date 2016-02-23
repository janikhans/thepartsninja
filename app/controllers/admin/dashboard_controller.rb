class Admin::DashboardController < ApplicationController
  include Admin
  before_action :admin_only
  layout "admin_dashboard"

  def index
    @users = User.all.count
    @leads = Lead.all.count
    @compatibles = Compatible.all.count
    @discoveries = Discovery.all.count
  end

end
