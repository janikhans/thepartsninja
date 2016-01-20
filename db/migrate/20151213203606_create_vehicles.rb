class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :model, null: false, default: ""
      t.integer :year, null: false
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
