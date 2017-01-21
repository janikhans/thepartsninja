class NeoFitment
  include Neo4j::ActiveRel

  property :fitment_id
  property :note
  property :location, type: String
  property :quantity, type: Integer
  property :source

  from_class :NeoPart
  to_class   :NeoVehicle
  type 'FITS'
end
