class Admin::AttributesController < Admin::ApplicationController
  def index
    @categories = Category.includes(:subcategories)
    @ebay_categories = EbayCategory.includes(:subcategories)
    @part_attributes = PartAttribute.includes(:attribute_variations)
    @vehicle_types = VehicleType.all
  end
end
