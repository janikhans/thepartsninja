class CreateFitments < ActiveRecord::Migration
  def change
    create_table :fitments do |t|
      t.references :part, index: true, foreign_key: true
      t.references :vehicle, index: true, foreign_key: true
      t.integer :discovery_id, index: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :fitments, [:part_id, :vehicle_id], unique: true
  end
end
