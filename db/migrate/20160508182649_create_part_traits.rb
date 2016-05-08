class CreatePartTraits < ActiveRecord::Migration
  def change
    create_table :part_traits do |t|
      t.references :part, index: true, foreign_key: true, null: false
      t.references :part_attribute, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
