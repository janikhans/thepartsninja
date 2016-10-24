class CompatibilityCheck
  attr_reader :results, :vehicle_one, :vehicle_two, :product_type, :part_attributes

  def initialize(params = {})
    @vehicle_one = Vehicle.find_by(id: params[:vehicle_one_id])
    @vehicle_two = Vehicle.find_by(id: params[:vehicle_two_id])
    @product_type = ProductType.find_by(id: params[:product_type_id])
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids)
    @fitment_note_id = params[:fitment_note_id]
  end

  # def process
  #   if @part_attribute_ids.blank?
  #     vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
  #     vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
  #   else
  #     # .oem_parts.joins(:fitment_notes, :product).where('products.product_type_id = ? AND fitment_notes.id = ?', @product_type_id, @fitment_note_id).select("DISTINCT parts.*")
  #     vehicle_one_parts = @vehicle_one.oem_parts.joins(:product, :part_attributes).where('products.product_type_id = ? AND part_attributes.id IN (?)', @product_type.id, @part_attribute_ids).includes(product: :brand)
  #     vehicle_two_parts = @vehicle_two.oem_parts.joins(:product, :part_attributes).where('products.product_type_id = ? AND part_attributes.id IN (?)', @product_type.id, @part_attribute_ids).includes(product: :brand)
  #   end
  #   @results = vehicle_one_parts & vehicle_two_parts
  # end

  def process
    if @fitment_note_id.blank?
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.product_type_id = ?', @product_type.id).includes(product: :brand)
    else
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:fitment_notes, :product).where('products.product_type_id = ? AND fitment_notes.id = ?', @product_type.id, @fitment_note_id).select("DISTINCT parts.*")
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:fitment_notes, :product).where('products.product_type_id = ? AND fitment_notes.id = ?', @product_type.id, @fitment_note_id).select("DISTINCT parts.*")
    end
    @results = vehicle_one_parts & vehicle_two_parts
  end
end
