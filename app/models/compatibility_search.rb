# Search type where results are a listing of vehicles that are related based
# on shared common parts
class CompatibilitySearch < ApplicationRecord
  include SearchableModel

  # TODO: rescue errors

  def process(options = {})
    return false unless valid?
    self.limit = options[:limit] if options[:limit].present?
    self.current_page = options[:page] if options[:page].present?
    self.threshold = options[:threshold] if options[:threshold].present?
    self.eager_load = options[:eager_load] ||= false
    self.search_type = options[:search_type] ||= 'known'
    perform_search
    self
  end

  private

  def perform_search
    return nil unless category
    find_results
    if successful?
      self.results_count = results.first.results_count
      self.grouped_count = results.first.grouped_count
      self.max_score = results.first.max_score
      self.above_threshold_count = results.first.above_threshold_count
    end
    eager_load_results if eager_load
  end

  def find_compatibilities
    if fitment_note_id.present?
      find_compatible_vehicles_with_fitment_note
    else
      find_compatible_vehicles
    end
  end

  def eager_load_results
    ActiveRecord::Associations::Preloader.new.preload(results, [:vehicle_year, vehicle_submodel: { vehicle_model: :brand }])
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
             COUNT(vehicles.id) AS vehicle_compatible_count
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
          GROUP BY vehicles.id
        ),
        vehicle_stats AS (
          SELECT id AS vehicle_id,
            (vehicle_compatible_count::FLOAT / MAX(vehicle_compatible_count) OVER ()) AS vehicle_score,
            CASE WHEN vehicle_compatible_count > ? THEN true
                 ELSE false
                 END AS above_threshold,
            COUNT(*) OVER () AS results_count,
            MAX(vehicle_compatible_count) OVER () AS max_score,
            COUNT(*) FILTER ( WHERE vehicle_compatible_count > ? ) OVER () AS above_threshold_count
          FROM vehicles
          GROUP BY vehicle_id, vehicle_compatible_count
        ),
        submodels AS (
          SELECT vehicle_submodel_id,
            COUNT(*) OVER () AS grouped_count,
            MAX(vehicle_compatible_count) AS submodel_score,
            COUNT(vehicles.id) AS submodel_vehicle_count
          FROM vehicles
          INNER JOIN vehicle_stats ON vehicle_stats.vehicle_id = vehicles.id
          GROUP BY vehicle_submodel_id
          HAVING MAX(vehicle_compatible_count) > ?
          ORDER BY submodel_score DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT vehicles.*, grouped_count, submodel_vehicle_count,
          vehicle_score, submodel_score, results_count, above_threshold,
          max_score, above_threshold_count
        FROM vehicles
        INNER JOIN submodels ON submodels.vehicle_submodel_id = vehicles.vehicle_submodel_id
        INNER JOIN vehicle_stats ON vehicle_stats.vehicle_id = vehicles.id
        ORDER BY submodel_score DESC, vehicle_score DESC
      ", vehicle_id, category_id, threshold, threshold, threshold, offset, limit])
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
             COUNT(vehicles.id) AS vehicle_compatible_count
          FROM parts
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN vehicles ON vehicles.id = fitments.vehicle_id
          GROUP BY vehicles.id
        ),
        vehicle_stats AS (
          SELECT id AS vehicle_id,
            (vehicle_compatible_count::FLOAT / MAX(vehicle_compatible_count) OVER ()) AS vehicle_score,
            CASE WHEN vehicle_compatible_count > ? THEN true
                 ELSE false
                 END AS above_threshold,
            COUNT(*) OVER () AS results_count,
            MAX(vehicle_compatible_count) OVER () AS max_score,
            COUNT(*) FILTER ( WHERE vehicle_compatible_count > ? ) OVER () AS above_threshold_count
          FROM vehicles
          GROUP BY vehicle_id, vehicle_compatible_count
        ),
        submodels AS (
          SELECT vehicle_submodel_id,
            COUNT(*) OVER () AS grouped_count,
            MAX(vehicle_compatible_count) AS submodel_score,
            COUNT(vehicles.id) AS submodel_vehicle_count
          FROM vehicles
          INNER JOIN vehicle_stats ON vehicle_stats.vehicle_id = vehicles.id
          GROUP BY vehicle_submodel_id
          HAVING MAX(vehicle_compatible_count) > ?
          ORDER BY submodel_score DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT vehicles.*, grouped_count, submodel_vehicle_count,
          vehicle_score, submodel_score, results_count, above_threshold,
          max_score, above_threshold_count
        FROM vehicles
        INNER JOIN submodels ON submodels.vehicle_submodel_id = vehicles.vehicle_submodel_id
        INNER JOIN vehicle_stats ON vehicle_stats.vehicle_id = vehicles.id
        ORDER BY submodel_score DESC, vehicle_score DESC
      ", vehicle_id, category_id, fitment_note_id, threshold, threshold, threshold, offset, limit])
  end

  def find_potentials
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
          SELECT vehicle_submodel_id, submodel_compatibility_count, COUNT(*) OVER() AS grouped_count
          FROM potential_vehicles
          GROUP BY vehicle_submodel_id, submodel_compatibility_count
          ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id
          OFFSET ?
          LIMIT ?
        )
        SELECT potential_vehicles.*, paginated_submodels.grouped_count
        FROM potential_vehicles
        INNER JOIN paginated_submodels ON paginated_submodels.vehicle_submodel_id = potential_vehicles.vehicle_submodel_id
        ORDER BY submodel_compatibility_count DESC, vehicle_submodel_id, vehicle_compatible_count, potential_vehicles.id
      ", vehicle_id, category_id, vehicle_id, category_id, threshold, offset, limit])
  end
end
