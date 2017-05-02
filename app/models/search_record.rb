class SearchRecord < ApplicationRecord
  belongs_to :searchable, polymorphic: true
  belongs_to :user
  belongs_to :category
  belongs_to :fitment_note
  belongs_to :vehicle
  belongs_to :comparing_vehicle, class_name: 'Vehicle'

  self.primary_key = 'id'

  def readonly?
    true
  end
end
