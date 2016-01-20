class CreateDiscoveries < ActiveRecord::Migration
  def change
    create_table :discoveries do |t|
      t.references :user, index: true, foreign_key: true
      t.text :comment
      t.boolean :modifications, null: false, default: false

      t.timestamps null: false
    end
  end
end
