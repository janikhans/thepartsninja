class NeoPart
  include Neo4j::ActiveNode

  id_property :part_id
  property :note

  has_many :both, :neo_vehicles, type: :FITS
end
