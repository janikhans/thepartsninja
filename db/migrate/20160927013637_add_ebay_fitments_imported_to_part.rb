class AddEbayFitmentsImportedToPart < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :ebay_fitments_imported, :boolean, default: false
  end
end
