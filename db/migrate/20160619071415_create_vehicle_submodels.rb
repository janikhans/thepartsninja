class CreateVehicleSubmodels < ActiveRecord::Migration
  def change
    create_table :vehicle_submodels do |t|
      t.references :vehicle_model, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
