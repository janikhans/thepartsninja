class CompatibilityCheck
  attr_reader :results, :vehicle_one, :vehicle_two, :category, :part_attributes

  def initialize(params = {})
    @vehicle_one = Vehicle.find_by(id: params[:vehicle_one_id])
    @vehicle_two = Vehicle.find_by(id: params[:vehicle_two_id])
    @category = Category.find_by(id: params[:category_id])
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids)
    @fitment_note_id = params[:fitment_note_id]
  end

  # def process
  #   if @part_attribute_ids.blank?
  #     vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.category_id = ?', @category.id).includes(product: :brand)
  #     vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.category_id = ?', @category.id).includes(product: :brand)
  #   else
  #     # .oem_parts.joins(:fitment_notes, :product).where('products.category_id = ? AND fitment_notes.id = ?', @category_id, @fitment_note_id).select("DISTINCT parts.*")
  #     vehicle_one_parts = @vehicle_one.oem_parts.joins(:product, :part_attributes).where('products.category_id = ? AND part_attributes.id IN (?)', @category.id, @part_attribute_ids).includes(product: :brand)
  #     vehicle_two_parts = @vehicle_two.oem_parts.joins(:product, :part_attributes).where('products.category_id = ? AND part_attributes.id IN (?)', @category.id, @part_attribute_ids).includes(product: :brand)
  #   end
  #   @results = vehicle_one_parts & vehicle_two_parts
  # end

  def process
    if @fitment_note_id.blank?
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:product).where('products.category_id = ?', @category.id).includes(product: :brand)
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:product).where('products.category_id = ?', @category.id).includes(product: :brand)
    else
      vehicle_one_parts = @vehicle_one.oem_parts.joins(:fitment_notes, :product).where('products.category_id = ? AND fitment_notes.id = ?', @category.id, @fitment_note_id).select("DISTINCT parts.*")
      vehicle_two_parts = @vehicle_two.oem_parts.joins(:fitment_notes, :product).where('products.category_id = ? AND fitment_notes.id = ?', @category.id, @fitment_note_id).select("DISTINCT parts.*")
    end
    @results = vehicle_one_parts & vehicle_two_parts
  end
end
