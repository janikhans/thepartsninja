class CompatibilitySearch < ApplicationRecord
  # TODO set defaults for processed? and page
  # rescue errors
  # limit by vehicle_submodel_id

  belongs_to :vehicle
  validates :vehicle, presence: true

  validates :category_name, presence: true

  belongs_to :category
  belongs_to :user
  belongs_to :fitment_note

  has_one :search_record, as: :searchable

  attr_accessor :compatible_vehicles, :model_count, :potential_vehicles

  def process(params = {})
    return false unless valid?
    self.limit = params[:limit] if params[:limit].present?
    self.current_page = params[:page] if params[:page].present?
    self.threshold = params[:threshold] if params[:threshold].present?
    self.compatible_vehicles = nil
    self.potential_vehicles = nil
    if params[:type] == :potentials
      self.potential_vehicles = find_potential_compatible_vehicles
    else
      self.compatible_vehicles = find_compatibilities
    end
    self.model_count = vehicles.first.submodel_count if vehicles.present?
    eager_load_vehicles if params[:eager_load] == true
    return self
  end

  def total_pages
    pages = model_count.to_f / limit
    pages.ceil
  end

  def can_advance_page?
    unless successful?
      raise ArgumentError, "search must be processed first"
    end
    current_page < total_pages
  end

  def next_page
    if can_advance_page?
      current_page + 1
    end
  end

  def current_page
    @current_page ||= 1
  end

  def successful?
    results_count.present? || compatible_parts.present? || potential_parts.present?
  end

  def vehicles
    compatible_vehicles || potential_vehicles
  end

  private

  def threshold=(value)
    unless (value.is_a? Integer) && value > 0
      raise ArgumentError, "expects a positive integer as threshold"
    end
    @threshold = value
  end

  def threshold
    @threshold ||= 20
  end

  def limit=(value)
    unless (value.is_a? Integer) && value > 0
      raise ArgumentError, "expects a positive integer as limit"
    end
    @limit = value
  end

  def limit
    @limit ||= 20
  end

  def current_page=(value)
    unless (value.is_a? Integer) && value > 0
      raise ArgumentError, "expects a positive integer as page number"
    end
    @current_page = value
  end

  def find_compatibilities
    if fitment_note_id.present?
      find_compatible_vehicles_with_fitment_note
    else
      find_compatible_vehicles
    end
  end

  def eager_load_vehicles
    ActiveRecord::Associations::Preloader.new.preload(vehicles, [:vehicle_year, vehicle_submodel: {vehicle_model: :brand}])
  end

  def find_compatible_vehicles
    Vehicle.find_by_sql(["
      WITH
        parts AS (
          SELECT parts.*
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN products ON products.id = parts.product_id
          WHERE fitments.vehicle_id = ? AND products.category_id = ?
        ),
        vehicles AS (
          SELECT vehicles.*,
             COUNT(vehicles.id) AS vehicle_compatible_count,
             SUM(COUNT(vehicles.id)) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_compatibility_count,
             COUNT(*) OVER() AS results_count
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
          GROUP BY vehicles.id
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id, vehicle_compatible_count DESC, vehicles.id
        ),
        submodels AS (
          SELECT vehicle_submodel_id, submodel_compatibility_count, COUNT(*) OVER() AS submodel_count
          FROM vehicles
          GROUP BY vehicle_submodel_id, submodel_compatibility_count
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT vehicles.*, submodels.submodel_count
        FROM vehicles
        INNER JOIN submodels ON submodels.vehicle_submodel_id = vehicles.vehicle_submodel_id
      ", vehicle_id, category_id, offset, limit])
  end

  def find_compatible_vehicles_with_fitment_note
    Vehicle.find_by_sql(["
      WITH
        parts AS (
          SELECT parts.*
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN products ON products.id = parts.product_id
          INNER JOIN fitment_notations ON fitment_notations.fitment_id = fitments.id
          WHERE fitments.vehicle_id = ? AND products.category_id = ? AND fitment_notations.fitment_note_id = ?
        ),
        vehicles AS (
          SELECT vehicles.*,
            COUNT(vehicles.id) AS vehicle_compatible_count,
            SUM(COUNT(vehicles.id)) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_compatibility_count,
            COUNT(*) OVER() AS results_count
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
          GROUP BY vehicles.id
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id, vehicle_compatible_count DESC, vehicles.id
        ),
        paginated_submodels AS (
          SELECT vehicle_submodel_id, submodel_compatibility_count, COUNT(*) OVER() AS submodel_count
          FROM vehicles
          GROUP BY vehicle_submodel_id, submodel_compatibility_count
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT vehicles.*, paginated_submodels.submodel_count
        FROM vehicles
        INNER JOIN paginated_submodels ON paginated_submodels.vehicle_submodel_id = vehicles.vehicle_submodel_id
        ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id, vehicle_compatible_count, vehicles.id
      ", vehicle_id, category_id, fitment_note_id, offset, limit])
  end

  def find_potential_compatible_vehicles
    Vehicle.find_by_sql(["
      WITH
        compatible_parts AS (
          SELECT parts.*
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN products ON products.id = parts.product_id
          WHERE fitments.vehicle_id = ? AND products.category_id = ?
        ),
        compatible_vehicles AS (
          SELECT vehicles.*, COUNT(vehicles.id) AS vehicle_compatible_count
          FROM compatible_parts
          INNER JOIN fitments ON fitments.part_id = compatible_parts.id
          INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
          WHERE vehicles.id != ?
          GROUP BY vehicles.id
          ORDER BY vehicle_compatible_count DESC, vehicles.id
        ),
        potential_parts AS (
          SELECT parts.*, COUNT(*) AS part_count
          FROM compatible_vehicles
          INNER JOIN fitments ON fitments.vehicle_id = compatible_vehicles.id
          INNER JOIN parts ON parts.id = fitments.part_id
          INNER JOIN products ON products.id = parts.product_id
          WHERE products.category_id = ? AND parts.id NOT IN ( SELECT id FROM compatible_parts WHERE id IS NOT NULL )
          GROUP BY parts.id
          ORDER BY part_count DESC
        ),
        potential_vehicles AS (
          SELECT vehicles.*, COUNT(*) as vehicle_compatible_count, SUM(potential_parts.part_count),
            SUM(COUNT(vehicles.id)) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_compatibility_count,
            COUNT(*) OVER() AS results_count
          FROM potential_parts
          INNER JOIN fitments ON fitments.part_id = potential_parts.id
          INNER JOIN vehicles ON fitments.vehicle_id = vehicles.id
          WHERE vehicles.id NOT IN ( SELECT id FROM compatible_vehicles WHERE id IS NOT NULL AND vehicle_compatible_count > ? )
          GROUP BY vehicles.id
          ORDER BY vehicle_compatible_count DESC, vehicles.id
        ),
        paginated_submodels AS (
          SELECT vehicle_submodel_id, submodel_compatibility_count, COUNT(*) OVER() AS submodel_count
          FROM potential_vehicles
          GROUP BY vehicle_submodel_id, submodel_compatibility_count
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT potential_vehicles.*, paginated_submodels.submodel_count
        FROM potential_vehicles
        INNER JOIN paginated_submodels ON paginated_submodels.vehicle_submodel_id = potential_vehicles.vehicle_submodel_id
        ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id, vehicle_compatible_count, potential_vehicles.id
      ", vehicle_id, category_id, vehicle_id, category_id, threshold, offset, limit])
  end

  def offset
    current_page * limit - limit
  end
end
