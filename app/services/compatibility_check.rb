class CompatibilityCheck
  attr_reader :results, :vehicle_one, :vehicle_two, :product_type, :part_attributes

  def initialize(params = {})
    @vehicle_one = Vehicle.find_by(id: params[:vehicle_one_id])
    @vehicle_two = Vehicle.find_by(id: params[:vehicle_two_id])
    @product_type = ProductType.find_by(id: params[:product_type_id])
    # FIXME temp hack because rails form sends an empty param through the form
    @part_attributes = params[:part_attributes].delete_if { |x| x.empty? }.first
  end

  def process
    if @part_attributes.blank?
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
    else
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:product, :part_attributes).where('products.product_type_id = ? AND part_attributes.id = ?', @product_type.id, @part_attributes).includes(product: :brand)
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:product, :part_attributes).where('products.product_type_id = ? AND part_attributes.id = ?', @product_type.id, @part_attributes).includes(product: :brand)
    end
    @results = vehicle_one_parts & vehicle_two_parts
  end
end
