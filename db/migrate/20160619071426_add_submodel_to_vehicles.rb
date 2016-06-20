class AddSubmodelToVehicles < ActiveRecord::Migration
  def change
    add_reference :vehicles, :vehicle_submodel, index: true, foreign_key: true
  end
end
