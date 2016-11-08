class Account::ActivityController < Account::ApplicationController
  def index
    @user = current_user
  end
end
