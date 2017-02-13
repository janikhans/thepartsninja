class UsersController < ApplicationController
  include Admin
  before_action :admin_only
  before_action :set_user, only: [:show]
  before_action :authenticate_user!

  def index
  end

  def show
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
