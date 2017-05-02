class CreateAvailableFitmentNotes < ActiveRecord::Migration
  def change
    create_view :available_fitment_notes, materialized: true
  end
end
