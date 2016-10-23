class AddEbayFitmentsUpdatedAtToParts < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :ebay_fitments_updated_at, :datetime
  end
end
