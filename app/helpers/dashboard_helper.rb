module DashboardHelper

  def resource_name
    :user
  end

  def resource
    @resource = current_user
  end

  def new_resource
    @resouce = User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
