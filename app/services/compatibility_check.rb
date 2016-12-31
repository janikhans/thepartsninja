class CompatibilityCheck
  # TODO add validations and error callbacks
  attr_reader :compatible_parts, :vehicles, :category, :part_attributes, :fitment_note

  def initialize(params = {})
    @vehicles = find_vehicles(params[:vehicles])
    @category = set_category(params)
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids) unless @part_attribute_ids.blank?
    @fitment_note = FitmentNote.find(params[:fitment_note_id]) unless params[:fitment_note_id].blank?
    @compatible_parts = []
  end

  def find_compatible_parts_sql
    return if @vehicles.blank? || @category.blank?
    compatible_parts = Part.joins(:product, :fitments).where('products.category_id = ? AND fitments.vehicle_id IN (?)', @category.id, @vehicles.pluck(:id))
    compatible_parts = compatible_parts.joins(:fitment_notes).where('fitment_notes.id = ?', @fitment_note.id) if @fitment_note.present?
    compatible_parts = compatible_parts.joins(:part_attributes).where('part_attributes.id IN (?)', @part_attributes.pluck(:id)) if @part_attributes.present?
    @compatible_parts = compatible_parts.select("DISTINCT parts.*").includes(product: :brand)
    return self
  end

  def find_compatible_parts
    return if @vehicles.blank? || @category.blank?
    vehicle_parts = []
    @vehicles.each do |vehicle|
      parts = vehicle.oem_parts.joins(:product).where('products.category_id = ?', @category.id)
      parts = parts.joins(:fitment_notes).where('fitment_notes.id = ?', @fitment_note.id) if @fitment_note.present?
      parts = parts.joins(:part_attributes).where('part_attributes.id IN (?)', @part_attribute.pluck(:id)) if @part_attributes.present?
      parts = parts.select("DISTINCT parts.*").includes(product: :brand)
      vehicle_parts << parts
    end
    @compatible_parts = vehicle_parts.inject(:&)
    return self
  end

  private

    def set_category(params)
      if params[:category_id].present?
        Category.find(params[:category_id])
      elsif params[:category_name].present?
        # Currently set so we're only using the Motrycycle Parts category Category.id => 1
        Category.first.descendants.leaves.where('lower(name) = ?', params[:category_name].downcase).first
      else
        # return error
      end
    end

    def find_vehicles(vehicles_array)
      return if vehicles_array.blank? # should add error
      vehicles = []
      vehicles_array.each do |vehicle|
        if vehicle[:id].present?
          vehicles << Vehicle.find(vehicle[:id])
        elsif vehicle[:brand].present? && vehicle[:model].present? && vehicle[:year].present?
          vehicles << Vehicle.find_with_specs(vehicle[:brand],vehicle[:model],vehicle[:year])
        else
          # return error
        end
      end
      return vehicles
    end
end
