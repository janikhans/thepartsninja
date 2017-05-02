class AvailableFitmentNote < ApplicationRecord
  belongs_to :category
  belongs_to :fitment_note

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false)
  end

  def readonly?
    true
  end

  self.primary_key = 'id'
end
