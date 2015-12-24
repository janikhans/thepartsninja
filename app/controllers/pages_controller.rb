class PagesController < ApplicationController
  def index
    @home_page = true
    @extra_class = "home"
  end

  def help
  end

  def contact
  end
end
