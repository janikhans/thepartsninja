class PagesController < ApplicationController
  autocomplete :brand, :name, :full => true
  autocomplete :category, :name, :full =>true, :scopes => [:subcategories]
  autocomplete :vehicle, :model, :full => true#, :scopes => [:unique_models]
  before_action :authenticate_user!, only: [:help, :contact, :about]


  def index
    @categories = Category.where(parent_id: !nil)
    @home_page = true
    @lead = Lead.new
  end

  def help
  end

  def contact
  end

  def terms
    prepare_meta_tags title: "Terms of Service"
  end

  def about
  end

  def privacy
    prepare_meta_tags title: "Privacy Policy"
  end
end
