class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :model, null: false, default: ""
      t.integer :year, null: false
      t.string :slug
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :vehicles, :slug,                unique: true
  end
end
