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

  attr_accessor :compatible_parts, :current_page

  def process(params = {})
    return false unless valid?
    self.current_page = params[:page] || 1
    raise ArgumentError, "expects an integer as page number" unless current_page.is_a? Integer
    self.compatible_parts = find_compatibilities
    eager_load_parts if params[:eager_load] == true
    return self
  end

  def total_pages
    pages = results_count.to_f / limit
    pages.ceil
  end

  def can_advance_page?
    raise ArgumentError, "search must be processed first" if compatible_parts.nil?
    current_page < total_pages
  end

  def next_page
    current_page + 1 if can_advance_page?
  end

  private

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
      SELECT parts.*, COUNT(*) OVER () as results_count
      FROM parts
      INNER JOIN products ON products.id = parts.product_id
      INNER JOIN fitments ON fitments.part_id = parts.id
      INNER JOIN fitment_notations ON fitments.id = fitment_notations.fitment_id
      WHERE products.category_id = ? AND fitments.vehicle_id IN (?) AND fitment_notations.fitment_note_id = ?
      GROUP BY parts.id
      HAVING count(*) > 1
      OFFSET ?
      LIMIT ?
      ", category_id, [vehicle_id, comparing_vehicle_id], fitment_note_id, offset, limit])
  end

  def find_compatible_parts
    Part.find_by_sql(["
      SELECT parts.*, COUNT(*) OVER () as results_count
      FROM parts
      INNER JOIN products ON products.id = parts.product_id
      INNER JOIN fitments ON fitments.part_id = parts.id
      WHERE products.category_id = ? AND fitments.vehicle_id IN (?)
      GROUP BY parts.id
      HAVING count(*) > 1
      OFFSET ?
      LIMIT ?
      ", category_id, [vehicle_id, comparing_vehicle_id], offset, limit])
  end

  def limit
    20
  end

  def offset
    current_page * limit - limit
  end
end
