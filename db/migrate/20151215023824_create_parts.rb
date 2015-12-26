class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :part_number
      t.text :note
      t.references :product, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
