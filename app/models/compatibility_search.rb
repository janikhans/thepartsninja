class CompatibilitySearch < ApplicationRecord
  belongs_to :vehicle
  validates :vehicle, presence: true

  validates :category_name, presence: true

  belongs_to :category
  belongs_to :user
  belongs_to :fitment_note

  has_one :search_record, as: :searchable
end
