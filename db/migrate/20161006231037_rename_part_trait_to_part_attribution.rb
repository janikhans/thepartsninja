class RenamePartTraitToPartAttribution < ActiveRecord::Migration[5.0]
  def change
    rename_table :part_traits, :part_attributions
  end
end
