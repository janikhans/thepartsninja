class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:help, :contact, :about, :search]

  def index
    @home_page = true
    @lead = Lead.new
  end

  def search
  end

  def help
  end

  def contact
  end

  def terms_of_service
    prepare_meta_tags title: "Terms of Service"
  end

  def about
  end

  def privacy_policy
    prepare_meta_tags title: "Privacy Policy"
  end
end
