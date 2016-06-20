class RemoveVehicleColumns < ActiveRecord::Migration
  def change
    remove_column :vehicles, :brand_id
    remove_column :vehicles, :model
  end
end
