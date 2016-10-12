class CompatibilityCheck
  attr_reader :results

  def initialize(params = {})
    @vehicle_one = Vehicle.find_by(id: params[:vehicle_one_id])
    @vehicle_two = Vehicle.find_by(id: params[:vehicle_two_id])
    @product_type = ProductType.find_by(id: params[:product_type_id])
    @results = []
  end

  def process
    vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id)
    vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id)
    @results = vehicle_one_parts & vehicle_two_parts
  end
end
