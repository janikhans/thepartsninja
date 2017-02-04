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
    # neo_compatible_vehicles = NeoVehicle.as(:v1).where(vehicle_id: @vehicle.id)
    #                             .neo_parts(:p).where(category_id: @category.id.to_s)
    #                             .neo_vehicles(:v2).count(:v2).as(:occurances)
    #                             .return(:v2, :occurances)
    #                             .order(occurances: :DESC)
    neo_compatible_vehicles = NeoVehicle.where(vehicle_id: @vehicle.id)
                                .neo_parts(:p)
                                .where(category_id: @category.id.to_s)
                                .neo_vehicles(:m)
                                .order('count(m) DESC')
                                .pluck(:m, 'count(m)')
    @compatible_vehicles = Vehicle.where(id: neo_compatible_vehicles.map{ |v| v.first.vehicle_id }).includes(:vehicle_year, vehicle_submodel: {vehicle_model: :brand})
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
end

# neo_compatible_vehicles = NeoVehicle.as(:v1).where(vehicle_id: 1).neo_parts(:p).where(category_id: "120").neo_vehicles(:v2).count(:v2).as(:occurances).return(:v2, :occurances).order(occurances: :DESC)
# NeoVehicle.match(v1: {NeoVehicle: {vehicle_id: 1}})
# NeoVehicle.where(vehicle_id: 1).neo_parts(:p).where(category_id: "120").neo_vehicles(:m).order('count(m)').pluck(:m, 'count(m)')
# NeoVehicle.where(vehicle_id: 1).neo_parts(:p).where(category_id: "120").neo_vehicles(:m).order('count(m)').query.return(:m, count: 'count(m)')
# Vehicle.where(vehicle_id: 1).parts(:p).where(category_id: "120").vehicles(:v2).order('count(m)').query.return(:m, count: 'count(m)')
