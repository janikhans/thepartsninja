class SetupEbayCategories < ActiveRecord::Migration[5.0]
  def change
    rename_table :categories, :ebay_categories
    rename_column :products, :category_id, :ebay_category_id
    create_table :categories do |t|
      t.string :name, null: false
      t.string :description
      t.integer :parent_id, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_reference :products, :category, index: true, foreign_key: true
  end
end
