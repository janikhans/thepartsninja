class PagesController < ApplicationController
  before_filter :set_search, only: [:index]

  def index
    @home_page = true
    @extra_class = "home"
  end

  def help
  end

  def contact
  end

  private
    def set_search
      @q = Vehicle.ransack(params[:q])
    end

end
