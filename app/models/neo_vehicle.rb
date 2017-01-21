class NeoVehicle
  include Neo4j::ActiveNode

  id_property :vehicle_id

  property :displacement, type: Integer
  property :displacement_units, type: String, default: "cc"

  has_many :both, :neo_parts, type: :FITS
end
