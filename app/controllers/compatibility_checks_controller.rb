class CompatibilityChecksController < ApplicationController
  before_action :authenticate_user!

  def new
    # Example params for testing
    # http://localhost:3000/compatibility-check?utf8=%E2%9C%93&category_id=120&vehicles%5B%5D%5Bbrand%5D=yamaha&vehicles%5B%5D%5Bmodel%5D=yz250&vehicles%5B%5D%5Byear%5D=2006&vehicles%5B%5D%5Bbrand%5D=yamaha&vehicles%5B%5D%5Bmodel%5D=yz450f&vehicles%5B%5D%5Byear%5D=2006
    # add fitment_note_id &fitment_note_id=4

    @brands = Brand.joins(:vehicles).where("vehicle_models.vehicle_type_id = 1").select("DISTINCT brands.*").order(name: :asc)
    @check = CompatibilityCheck.new(url_check_params)
    if @check.find_compatible_parts
      @products = @check.compatible_parts.group_by { |s| s.product }
      search_term = @check.vehicles.first.to_label + " " + @check.category.name
      @ebay_results = YaberAdvancedListing.search(search_term, 5)
    end

    @neo_check = NeoCompatibilityCheck.new(url_check_params).process!
  end

  def results
    # @check = CompatibilityCheck.new(compatibility_check_params)
    binding.pry
    @check = NeoCompatibilityCheck.new(compatibility_check_params)
    if @check.process!
      @products = @check.products
      search_term = @check.vehicles.first.to_label + " " + @check.category.name
      @ebay_results = YaberAdvancedListing.search(search_term, 5)
      respond_to :js
    else
      # repsond_to :js and show errors
    end
    # if @check.find_compatible_parts
    #     @products = @check.compatible_parts.group_by { |s| s.product }
    #     search_term = @check.vehicles.first.to_label + " " + @check.category.name
    #     @ebay_results = YaberAdvancedListing.search(search_term, 5)
    #   respond_to :js
    # else
    #   "damn..."
    # end
  end

  private

  def url_check_params
    params.permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicles: [:brand, :model, :year, :id])
  end

  def compatibility_check_params
    params.require(:compatibility_check).permit(:category_id, :category_name, :fitment_note_id, part_attributes: [], vehicles: [:id])
  end
end
