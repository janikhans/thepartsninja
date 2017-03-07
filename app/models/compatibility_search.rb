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

  attr_accessor :compatible_vehicles, :current_page, :model_count

  def process(params = {})
    return false unless valid?
    self.current_page = params[:page] || 1
    raise ArgumentError, "expects an integer as page number" unless current_page.is_a? Integer
    self.compatible_vehicles = find_compatibilities
    self.model_count = compatible_vehicles.first.submodel_count if compatible_vehicles.any?
    eager_load_vehicles if params[:eager_load] == true
    return self
  end

  def total_pages
    pages = model_count.to_f / limit
    pages.ceil
  end

  def can_advance_page?
    raise ArgumentError, "search must be processed first" if compatible_vehicles.nil?
    current_page < total_pages
  end

  def next_page
    current_page + 1 if can_advance_page?
  end

  private

  def find_compatibilities
    if fitment_note_id.present?
      find_compatible_vehicles_with_fitment_note
    else
      find_compatible_vehicles
    end
  end

  def eager_load_vehicles
    ActiveRecord::Associations::Preloader.new.preload(compatible_vehicles, [:vehicle_year, vehicle_submodel: {vehicle_model: :brand}])
  end

  def find_compatible_vehicles
    Vehicle.find_by_sql(["
      WITH
        vehicles AS (
          SELECT vehicles.*,
             COUNT(vehicles.id) AS vehicle_compatible_count,
             SUM(COUNT(vehicles.id)) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_compatibility_count,
             COUNT(*) OVER() AS results_count
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
        vehicles AS (
          SELECT vehicles.*,
             COUNT(vehicles.id) AS vehicle_compatible_count,
             SUM(COUNT(vehicles.id)) OVER (PARTITION BY vehicles.vehicle_submodel_id) AS submodel_compatibility_count,
             COUNT(*) OVER() AS results_count
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

  def limit
    5
  end

  def offset
    current_page * limit - limit
  end
end
