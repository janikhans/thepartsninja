class ForceCreateNeoPartPartIdConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :NeoPart, :part_id, force: true
  end

  def down
    drop_constraint :NeoPart, :part_id
  end
end
