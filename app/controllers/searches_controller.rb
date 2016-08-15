class SearchesController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def results
    @search = SearchForm.new(params[:search])

    if user_signed_in?
      @search.results(current_user)
    else
      @search.results(current_user = nil)
      redirect_to coming_soon_path
    end
  end
end
