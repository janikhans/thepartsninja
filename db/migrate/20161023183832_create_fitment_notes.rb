class CreateFitmentNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :fitment_notes do |t|
      t.string :name, null: false
      t.integer :parent_id, index: true, foreign_key: true
      t.boolean :used_for_search, default: false

      t.timestamps
    end
  end
end
