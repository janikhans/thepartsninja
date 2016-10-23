class AddNotesToFitments < ActiveRecord::Migration[5.0]
  def change
    add_column :fitments, :note, :text
  end
end
