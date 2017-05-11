class AddAttributesToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :searchable, :boolean, default: false
    add_column :categories, :fitment_notable, :boolean, default: false
  end
end
