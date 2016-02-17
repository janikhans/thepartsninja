class PagesController < ApplicationController


  def index
    @search
    @home_page = true
    @extra_class = "home"
  end

  def help
  end

  def contact
  end

  def terms
  end


end
