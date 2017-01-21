class ForceCreateNeoVehicleVehicleIdConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :NeoVehicle, :vehicle_id, force: true
  end

  def down
    drop_constraint :NeoVehicle, :vehicle_id
  end
end
