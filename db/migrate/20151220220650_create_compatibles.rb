class CreateCompatibles < ActiveRecord::Migration
  def change
    create_table :compatibles do |t|
      t.integer :fitment_id, index: true, foreign_key: true
      t.integer :compatible_fitment_id, index: true, foreign_key: true
      t.integer :discovery_id, index: true, foreign_key: true
      t.boolean :verified, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
