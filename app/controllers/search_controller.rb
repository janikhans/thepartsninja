class SearchController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def new
  end

  def find_compatibilities
    respond_to :js
  end

  def check_compatibility
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
    respond_to :js
  end

  def refresh_buttons
    respond_to :js
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
