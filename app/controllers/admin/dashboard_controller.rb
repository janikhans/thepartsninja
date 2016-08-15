class Admin::DashboardController < ApplicationController
  include Admin
  before_action :admin_only
  layout "admin_dashboard"

  def index
    @users = User.count
    @leads = Lead.where(created_at: (Time.now - 24.hours)..Time.now).count
    @discoveries = Discovery.count
    @searches = Search.where(created_at: (Time.now - 24.hours)..Time.now).count
  end
end
