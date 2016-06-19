class AddVehicleYearReferencesVehicles < ActiveRecord::Migration
  def change
    remove_column :vehicles, :year
    add_reference :vehicles, :vehicle_year, index: true, foreign_key: true
  end
end
