class CreateProductTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :product_types do |t|
      t.references :category, foreign_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
