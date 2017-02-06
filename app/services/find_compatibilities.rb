class FindCompatibilities
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  # TODO add validations and error callbacks
  attr_accessor :category_name, :category_id, :vehicle, :fitment_note_id, :fitment_note_name, :part_attributes,
    :vehicle_brand, :vehicle_model, :vehicle_submodel, :vehicle_year

  attr_reader :compatible_vehicles, :vehicle, :category, :part_attributes, :fitment_note

  validates :category, presence: true
  validates :vehicle, presence: true

  def initialize(params = {})
    @vehicle = set_vehicle(params[:vehicle])
    @category = set_category(params)
    @fitment_note = set_fitment_note(params)
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids) if @part_attribute_ids.present?
    @compatible_vehicles = []
  end

  def process
    return false unless valid?
    return if @vehicle.blank? || @category.blank?
    if @fitment_note.present?
      @compatible_vehicles = find_compatible_vehicles_with_fitment_note(@vehicle, @category.id, @fitment_note.id)
    else
      @compatible_vehicles = find_compatible_vehicles(@vehicle, @category.id)
    end
    ActiveRecord::Associations::Preloader.new.preload(@compatible_vehicles, [:vehicle_year, vehicle_submodel: {vehicle_model: :brand}])
    return self
  end

  private

    def set_category(params)
      if params[:category_id].present?
        Category.find_by_id(params[:category_id])
      elsif params[:category_name].present?
        # Currently set so we're only using the Motrycycle Parts category Category.id => 1
        Category.first.descendants.leaves.where('lower(name) = ?', params[:category_name].downcase).first
      else
        # return error
      end
    end

    def set_fitment_note(params)
      if params[:fitment_note_id].present?
        FitmentNote.find_by_id(params[:fitment_note_id])
      elsif params[:fitment_note_name].present?
        FitmentNote.where('lower(name) = ?', params[:fitment_note_name].downcase).first
      else
        # return error
      end
    end

    def set_vehicle(vehicle_params)
      return if vehicle_params.blank? # should add error
      if vehicle_params[:id].present?
        vehicle = Vehicle.find_by_id(vehicle_params[:id])
      elsif vehicle_params[:brand].present? && vehicle_params[:model].present? && vehicle_params[:year].present?
        vehicle = Vehicle.find_with_specs(vehicle_params[:brand],vehicle_params[:model],vehicle_params[:year])
      else
        # return error
      end
      return vehicle
    end

    def find_compatible_vehicles(vehicle_id, category_id)
      Vehicle.find_by_sql(["
        SELECT vehicles.*,
          COUNT(vehicles.id) AS compatible_count,
          COUNT(vehicles.id) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_count
        FROM (
          SELECT parts.*
          FROM vehicles
          INNER JOIN fitments ON fitments.vehicle_id = vehicles.id
          INNER JOIN parts ON parts.id = fitments.part_id
          INNER JOIN products ON products.id = parts.product_id
          WHERE vehicles.id = ? AND products.category_id = ?
        ) AS parts
        INNER JOIN fitments ON fitments.part_id = parts.id
        INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
        GROUP BY vehicles.id
        ORDER BY submodel_count DESC, compatible_count DESC, vehicles.vehicle_submodel_id, vehicles.id
        LIMIT 100
        ",vehicle_id, category_id])
    end

    def find_compatible_vehicles_with_fitment_note(vehicle_id, category_id, fitment_id)
      Vehicle.find_by_sql(["
        SELECT vehicles.*,
          COUNT(vehicles.id) AS compatible_count,
          COUNT(vehicles.id) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_count
        FROM (
          SELECT parts.*
          FROM vehicles
          INNER JOIN fitments ON fitments.vehicle_id = vehicles.id
          INNER JOIN fitment_notations ON fitment_notations.fitment_id = fitments.id
          INNER JOIN parts ON parts.id = fitments.part_id
          INNER JOIN products ON products.id = parts.product_id
          WHERE vehicles.id = ? AND products.category_id = ? AND fitment_notations.fitment_note_id = ?
        ) AS parts
        INNER JOIN fitments ON fitments.part_id = parts.id
        INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
        WHERE vehicles.id != ?
        GROUP BY vehicles.id
        ORDER BY submodel_count DESC, vehicles.vehicle_submodel_id ASC, compatible_count DESC, vehicles.id
        LIMIT 100
        ",vehicle_id, category_id, fitment_id, vehicle_id])
    end
end
