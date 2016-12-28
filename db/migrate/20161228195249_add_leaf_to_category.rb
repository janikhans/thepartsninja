class AddLeafToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :leaf, :boolean, default: false
  end
end
