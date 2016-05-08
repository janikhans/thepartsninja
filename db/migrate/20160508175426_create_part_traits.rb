class CreatePartTraits < ActiveRecord::Migration
  def change
    create_table :part_traits do |t|
      t.references :Part, index: true, foreign_key: true, null: false
      t.references :PartAttribute, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
