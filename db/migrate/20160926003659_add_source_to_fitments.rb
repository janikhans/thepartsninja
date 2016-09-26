class AddSourceToFitments < ActiveRecord::Migration[5.0]
  def change
    add_column :fitments, :source, :integer
  end
end
