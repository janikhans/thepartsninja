class CreateFitments < ActiveRecord::Migration
  def change
    create_table :fitments do |t|
      t.references :vehicle, index: true, foreign_key: true
      t.references :part, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :oem, default: false
      t.boolean :verified, default: false

      t.timestamps null: false
    end
  end
end
