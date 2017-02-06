class SearchController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def new
  end

  def results
    @search = SearchForm.new(search_params)

    if user_signed_in?
      @search.results(current_user)
    else
      @search.results(current_user = nil)
      redirect_to coming_soon_path
    end
  end

  private

  def search_params
    params.require(:search).permit(:year, :brand, :model, :part)
  end
end
