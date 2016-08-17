class Admin::AttributesController < Admin::DashboardController
  def index
    @categories = Category.includes(:subcategories)
    @part_attributes = PartAttribute.includes(:attribute_variations)
    @vehicle_types = VehicleType.all
  end
end
