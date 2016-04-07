class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :user, index: true, foreign_key: true
      t.references :vehicle, index: true, foreign_key: true
      t.string :brand
      t.string :model
      t.integer :year
      t.string :part
      t.integer :compatibles, default: 0
      t.integer :potentials, default: 0

      t.timestamps null: false
    end
  end
end
