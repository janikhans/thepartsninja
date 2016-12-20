class DropProductTypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :product_type_id
    drop_table :product_types
  end
end
