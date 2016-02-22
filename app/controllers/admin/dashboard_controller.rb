class Admin::DashboardController < ApplicationController
  include Admin
  before_filter :admin_only

  def index
  end
  
end
