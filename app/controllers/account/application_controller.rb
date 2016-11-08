class Account::ApplicationController < ApplicationController
  before_action :authenticate_user!
  layout 'account/application'
end
