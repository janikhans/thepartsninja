class UpdateCompatibleToCompatibility < ActiveRecord::Migration[5.0]
  def change
    rename_table :compatibles, :compatibilities
    add_column :compatibilities, :modifications, :boolean, default: false, null: false
    remove_column :discoveries, :modifications
  end
end
