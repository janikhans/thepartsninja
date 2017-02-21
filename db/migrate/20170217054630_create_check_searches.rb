class CreateCheckSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :check_searches do |t|
      t.references :user, foreign_key: true, index: true
      t.references :vehicle, foreign_key: true, index: true, null: false
      t.integer :comparing_vehicle_id, foreign_key: true, index: true, null: false
      t.references :category, foreign_key: true, index: true
      t.string :category_name, null: false
      t.integer :results_count
      t.references :fitment_note, foreign_key: true, index: true

      t.timestamps
    end
  end
end
