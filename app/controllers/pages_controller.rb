class PagesController < ApplicationController
  autocomplete :brand, :name, :full => true
  autocomplete :category, :name, :full =>true, :scopes => [:subcategories]
  autocomplete :vehicle, :model, :full => true, :scopes => [:unique_models]


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
