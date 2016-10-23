class CreateFitmentNotations < ActiveRecord::Migration[5.0]
  def change
    create_table :fitment_notations do |t|
      t.references :fitment, index: true, foreign_key: true, null: false
      t.references :fitment_note, index: true, foreign_key: true, null: false

      t.timestamps
    end
    add_index :fitment_notations, [:fitment_id, :fitment_note_id], unique: true
  end
end
