class CheckSearch < ApplicationRecord
  include SearchableModel

  belongs_to :comparing_vehicle, class_name: 'Vehicle'
  validates :comparing_vehicle, presence: true

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
    end
    eager_load_results if eager_load
  end

  def find_compatibilities
    if fitment_note_id.present?
      find_compatible_parts_with_fitment_note
    else
      find_compatible_parts
    end
  end

  def find_potentials
  end

  def eager_load_results
    ActiveRecord::Associations::Preloader.new.preload(results, product: :brand)
  end

  def find_compatible_parts_with_fitment_note
    Part.find_by_sql(["
      WITH
        parts AS (
          SELECT parts.*, COUNT(*) as part_count, COUNT(*) OVER () as results_count
          FROM parts
          INNER JOIN products ON products.id = parts.product_id
          INNER JOIN fitments ON fitments.part_id = parts.id
          INNER JOIN fitment_notations ON fitments.id = fitment_notations.fitment_id
          WHERE products.category_id = ? AND fitments.vehicle_id IN (?) AND fitment_notations.fitment_note_id = ?
          GROUP BY parts.id
          HAVING count(*) > 1
        ),
        products AS (
          SELECT product_id, part_count, COUNT(*) OVER() AS grouped_count
          FROM parts
          GROUP BY product_id, part_count
          OFFSET ?
          LIMIT ?
        )
        SELECT parts.*, products.grouped_count
        FROM parts
        INNER JOIN products ON products.product_id = parts.product_id
      ", category_id, [vehicle_id, comparing_vehicle_id], fitment_note_id, offset, limit])
  end

  def find_compatible_parts
    Part.find_by_sql(["
      WITH
        parts AS (
          SELECT parts.*, COUNT(*) as part_count, COUNT(*) OVER () as results_count
          FROM parts
          INNER JOIN products ON products.id = parts.product_id
          INNER JOIN fitments ON fitments.part_id = parts.id
          WHERE products.category_id = ? AND fitments.vehicle_id IN (?)
          GROUP BY parts.id
          HAVING count(*) > 1
        ),
        products AS (
          SELECT product_id, part_count, COUNT(*) OVER() AS grouped_count
          FROM parts
          GROUP BY product_id, part_count
          OFFSET ?
          LIMIT ?
        )
        SELECT parts.*, products.grouped_count
        FROM parts
        INNER JOIN products ON products.product_id = parts.product_id
      ", category_id, [vehicle_id, comparing_vehicle_id], offset, limit])
  end

  def find_potential_parts
    Part.find_by_sql(["
      WITH
        compatible_vehicles AS (
          SELECT vehicles.*,
             COUNT(vehicles.id) AS vehicle_compatible_count
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
          ORDER BY vehicle_compatible_count DESC, vehicles.id
        )
        SELECT parts.*
        FROM vehicles
        INNER JOIN fitments ON fitments.vehicle_id = vehicles.id
        INNER JOIN parts ON parts.id = fitments.part_id
        INNER JOIN products ON products.id = parts.product_id
        WHERE vehicles.id IN (SELECT id FROM compatible_vehicles) AND products.category_id = ?
      ", vehicle_id, category_id, offset, limit])
  end
end
