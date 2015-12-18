class RenamePartDescriptionColumn < ActiveRecord::Migration
  def change
    rename_column :parts, :description, :note
  end
end
