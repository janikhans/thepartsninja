class SearchController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def new
  end

  def find_compatibilities
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
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

  def compat_results
    @search = NeoFindCompatibles.new(compat_params)
    @search.process!
  end

  private

  def search_params
    params.require(:search).permit(:year, :brand, :model, :part)
  end

  def compat_params
    params.require(:compat).permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicles: [:id])
  end
end
