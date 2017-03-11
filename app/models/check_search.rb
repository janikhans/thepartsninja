class CheckSearch < ApplicationRecord
  belongs_to :vehicle
  validates :vehicle, presence: true

  belongs_to :comparing_vehicle, class_name: "Vehicle"
  validates :comparing_vehicle, presence: true

  belongs_to :category
  belongs_to :user
  belongs_to :fitment_note

  validates :category_name, presence: true

  has_one :search_record, as: :searchable

  attr_accessor :compatible_parts

  def process(params = {})
    return false unless valid?
    self.limit = params[:limit] if params[:limit].present?
    self.current_page = params[:page] if params[:page].present?
    self.compatible_parts = find_compatibilities
    eager_load_parts if params[:eager_load] == true
    return self
  end

  def total_pages
    pages = results_count.to_f / limit
    pages.ceil
  end

  def can_advance_page?
    raise ArgumentError, "search must be processed first" unless successful?
    current_page < total_pages
  end

  def next_page
    current_page + 1 if can_advance_page?
  end

  def successful?
    results_count.present? || compatible_parts.any?
  end

  def current_page
    @current_page ||= 1
  end

  private

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
      find_compatible_parts_with_fitment_note
    else
      find_compatible_parts
    end
  end

  def eager_load_parts
    ActiveRecord::Associations::Preloader.new.preload(compatible_parts, product: :brand)
  end

  def find_compatible_parts_with_fitment_note
    Part.find_by_sql(["
      SELECT *, COUNT(*) OVER () as results_count
      FROM (
        SELECT parts.*, COUNT(*) as part_count
        FROM parts
        INNER JOIN products ON products.id = parts.product_id
        INNER JOIN fitments ON fitments.part_id = parts.id
        INNER JOIN fitment_notations ON fitments.id = fitment_notations.fitment_id
        WHERE products.category_id = ? AND fitments.vehicle_id IN (?) AND fitment_notations.fitment_note_id = ?
        GROUP BY parts.id
        HAVING count(*) > 1
        ) AS parts
      OFFSET ?
      LIMIT ?
      ", category_id, [vehicle_id, comparing_vehicle_id], fitment_note_id, offset, limit])
  end

  def find_compatible_parts
    Part.find_by_sql(["
      SELECT *, COUNT(*) OVER () as results_count
      FROM (
        SELECT parts.*, COUNT(*) as part_count
        FROM parts
        INNER JOIN products ON products.id = parts.product_id
        INNER JOIN fitments ON fitments.part_id = parts.id
        WHERE products.category_id = ? AND fitments.vehicle_id IN (?)
        GROUP BY parts.id
        HAVING count(*) > 1
        ) AS parts
      OFFSET ?
      LIMIT ?
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

  def offset
    current_page * limit - limit
  end
end
