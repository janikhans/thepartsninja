class CreateVehicleYears < ActiveRecord::Migration
  def change
    create_table :vehicle_years do |t|
      t.integer :year, null: false

      t.timestamps null: false
    end
  end
end
