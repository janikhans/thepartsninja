class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :model
      t.integer :year
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
