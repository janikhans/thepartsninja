class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :location
      t.text :bio

      t.timestamps null: false
    end
  end
end
