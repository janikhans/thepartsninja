class PagesController < ApplicationController


  def index
    @lead = Lead.new
    @categories = Category.where(parent_id: !nil)
    @search = Search.new
    @home_page = true
  end

  def help
  end

  def contact
  end

  def terms
  end


end
