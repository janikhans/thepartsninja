class Forum::ApplicationController < ApplicationController
  before_action :authenticate_user!
  layout 'forum/application'
end
