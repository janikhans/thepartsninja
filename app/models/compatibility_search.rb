class CompatibilitySearch < ApplicationRecord
  belongs_to :vehicle
  validates :vehicle, presence: true

  validates :category_name, presence: true

  belongs_to :category
  belongs_to :user

  has_one :search_record, as: :searchable
end
