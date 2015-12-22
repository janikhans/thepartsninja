class CreateDiscoveries < ActiveRecord::Migration
  def change
    create_table :discoveries do |t|
      t.references :user, index: true, foreign_key: true
      t.text :comment
      t.boolean :modifications

      t.timestamps null: false
    end
  end
end
