class AddFromEbayToCategories < ActiveRecord::Migration[5.0]
  def up
    add_column :categories, :type, :string
    execute "UPDATE categories
             SET type = 'EbayCategory'"
  end

  def down
    remove_column :categories, :type
  end
end
