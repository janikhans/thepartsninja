class Admin::ApplicationController < ApplicationController
  include Admin
  before_action :admin_only
  layout "admin/application"
end
