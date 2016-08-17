class AddEPidToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :epid, :integer, index: true
  end
end
