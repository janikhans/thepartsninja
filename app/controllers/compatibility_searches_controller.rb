class CompatibilitySearchesController < ApplicationController
  before_action :authenticate_user!

  def new
    @search = CompatibilitySearchForm.new
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/find/results?utf8=%E2%9C%93&search%5Bcategory_name%5D=brake+pads&search%5Bvehicle%5D%5Bid%5D=35606

  def results
    respond_to do |format|
      if params[:search].present?
        @search = CompatibilitySearchForm.new(search_params)
        @search.user = current_user
        if @search.save
          @compatibility_search = @search.compatibility_search
          format.html
          format.js
        else
          format.html
          format.js
        end
      else
        format.html { redirect_to find_path }
      end
    end
  end

  def show
    @page = params[:page].to_i
    @compatibility_search = CompatibilitySearch.find_by(id: params[:id])
    @compatibility_search.process(page: @page, eager_load: true)
    respond_to :js
  end

  private

  def search_params
    params.require(:search).permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicle: [:brand, :model, :year, :id])
  end
end
