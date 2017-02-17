class CreateCheckSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :check_searches do |t|
      t.references :user, foreign_key: true, index: true
      t.integer :vehicle_one_id, foreign_key: true, index: true, null: false
      t.integer :vehicle_two_id, foreign_key: true, index: true, null: false
      t.references :category, foreign_key: true, index: true
      t.string :category_name, null: false

      t.timestamps
    end
  end
end
