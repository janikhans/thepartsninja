class AddAncestryToEbayCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :ebay_categories, :ancestry, :string
    add_index :ebay_categories, :ancestry
  end
end
