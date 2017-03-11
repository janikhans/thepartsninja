class CheckSearchesController < ApplicationController
  before_action :authenticate_user!

  def new
    @search = CheckSearchForm.new
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/check/results?utf8=%E2%9C%93&compatibility_check%5Bcategory_name%5D=brake+pads&compatibility_check%5Bvehicles%5D%5B%5D%5Bid%5D=1&compatibility_check%5Bvehicles%5D%5B%5D%5Bid%5D=10834&compatibility_check%5Bfitment_note_id%5D=&commit=Check
  # add fitment_note_id &fitment_note_id=4

  def results
    respond_to do |format|
      if params[:search].present?
        @search = CheckSearchForm.new(search_params)
        @search.user = current_user
        if @search.save
          @check_search = @search.check_search
          format.html
          format.js
        else
          format.html
          format.js
        end
      else
        format.html { redirect_to check_index_path }
      end
    end
  end

  def show
    @page = params[:page].to_i
    @check_search = CheckSearch.find_by(id: params[:id])
    @check_search.process(page: @page, eager_load: true)
    @products = @check_search.compatible_parts.group_by { |s| s.product }.sort_by { |products, parts| parts.size }.reverse
    respond_to :js
  end

  private

  def search_params
    params.require(:search).permit(category: [:name, :id], fitment_note: :id, vehicle: [:brand, :model, :year, :id], comparing_vehicle: [:brand, :model, :year, :id])
  end
end
