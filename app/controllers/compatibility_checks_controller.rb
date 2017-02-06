class CompatibilityChecksController < ApplicationController
  before_action :authenticate_user!

  def new
    @compatibility_check = CompatibilityCheck.new
    @brands = Brand.joins(:vehicles).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
  end

  # Example params for testing
  # http://localhost:3000/check/results?utf8=%E2%9C%93&compatibility_check%5Bcategory_name%5D=brake+pads&compatibility_check%5Bvehicles%5D%5B%5D%5Bid%5D=1&compatibility_check%5Bvehicles%5D%5B%5D%5Bid%5D=10834&compatibility_check%5Bfitment_note_id%5D=&commit=Check
  # add fitment_note_id &fitment_note_id=4

  def results
    respond_to do |format|
      if params[:compatibility_check].present?
        @compatibility_check = CompatibilityCheck.new(check_params)
        if @compatibility_check.process
          @products = @compatibility_check.compatible_parts.group_by { |s| s.product }
          search_term = @compatibility_check.vehicles.first.to_label + " " + @compatibility_check.category.name
          @ebay_results = YaberAdvancedListing.search(search_term, 5)
          format.html
          format.js
        else
          format.html
          format.js
        end
      else
        format.html { redirect_to check_path }
      end
    end
  end

  private

  def check_params
    params.require(:compatibility_check).permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicles: [:brand, :model, :year, :id])
  end
end
