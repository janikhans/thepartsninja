class Admin::DashboardController < ApplicationController
  include Admin
  before_filter :admin_only
  layout "admin_dashboard"

  def index
  end

end
