class NeoCompatibilityCheck
  # TODO add validations and error callbacks
  attr_reader :compatible_parts, :vehicles, :category, :part_attributes, :fitment_note, :compatible_parts

  def initialize(params = {})
    @vehicles = find_vehicles(params[:vehicles])
    @category = set_category(params)
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids) if @part_attribute_ids.present?
    @fitment_note = FitmentNote.find(params[:fitment_note_id]) if params[:fitment_note_id].present?
    @compatible_parts = []
  end

  def process!
    return if @vehicles.blank? || @category.blank?
    neo_compatible_parts = NeoVehicle.as(:v1).where(vehicle_id: @vehicles.first.id)
                            .neo_parts(:p).where(category_id: @category.id.to_s)
                            .neo_vehicles(:v2).where(vehicle_id: @vehicles.second.id)
                            .pluck('p.part_id')
    @compatible_parts = Part.where(id: neo_compatible_parts).includes(product: :brand)
    return self
  end

  def products
    self.compatible_parts.group_by { |s| s.product }
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
