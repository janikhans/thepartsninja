class AddProductTypeToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :product_type, index: true, foreign_key: true
  end
end
