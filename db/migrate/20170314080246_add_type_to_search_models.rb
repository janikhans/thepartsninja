class AddTypeToSearchModels < ActiveRecord::Migration[5.0]
  def change
    add_column :compatibility_searches, :search_type, :integer
    add_column :check_searches, :search_type, :integer
  end
end
