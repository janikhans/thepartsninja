class FindCompatibilitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @find_compatibilities = FindCompatibilities.new
    @brands = Brand.joins(:vehicle_models).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/find/results?utf8=%E2%9C%93&find_compatibilities%5Bcategory_name%5D=brake+pads&find_compatibilities%5Bvehicle%5D%5Bid%5D=35606

  def results
    respond_to do |format|
      if params[:find_compatibilities].present?
        @find_compatibilities = FindCompatibilities.new(find_compatibilities_params)
        @find_compatibilities.user = current_user
        if @find_compatibilities.process
          # search_term = @find_compatibilities.vehicle.to_label + " " + @find_compatibilities.category.name
          # @ebay_results = YaberAdvancedListing.search(search_term, 5)
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

  private

  def find_compatibilities_params
    params.require(:find_compatibilities).permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicle: [:brand, :model, :year, :id])
  end
end
