class PagesController < ApplicationController


  def index
    @categories = Category.where(parent_id: !nil)
    @home_page = true
  end

  def help
  end

  def contact
  end

  def terms
  end


end
