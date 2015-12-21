class CreateCompatibles < ActiveRecord::Migration
  def change
    create_table :compatibles do |t|
      t.integer :original_id
      t.integer :replaces_id
      t.integer :discovery_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
