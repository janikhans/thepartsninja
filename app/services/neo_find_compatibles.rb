class NeoFindCompatibles
  # TODO add validations and error callbacks
  attr_reader :compatible_vehicles, :vehicle, :category, :part_attributes, :fitment_note

  def initialize(params = {})
    @vehicle = set_vehicle(params[:vehicle])
    @category = set_category(params)
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids) if @part_attribute_ids.present?
    @fitment_note = FitmentNote.find(params[:fitment_note_id]) if params[:fitment_note_id].present?
    @compatible_vehicles = []
  end

  def process!
    return if @vehicle.blank? || @category.blank?
    neo_compatible_vehicles = NeoVehicle.as(:v1).where(vehicle_id: @vehicle.id)
    neo_compatible_parts = NeoVehicle.as(:v1).where(vehicle_id: @vehicles.first.id)
                            .neo_parts(:p).where(category_id: @category.id.to_s)
                            .neo_vehicles(:v2).where(vehicle_id: @vehicles.second.id)
                            .pluck('p.part_id')
    @compatible_vehicles = Part.where(id: neo_compatible_parts).includes(product: :brand)
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

    def set_vehicle(vehicle_params)
      return if vehicle_params.blank? # should add error
      if vehicle_params[:id].present?
        vehicle = Vehicle.find(vehicle_params[:id])
      elsif vehicle_params[:brand].present? && vehicle_params[:model].present? && vehicle_params[:year].present?
        vehicle = Vehicle.find_with_specs(vehicle_params[:brand],vehicle_params[:model],vehicle_params[:year])
      else
        # return error
      end
      return vehicle
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
