class AddScoreSearchModels < ActiveRecord::Migration[5.0]
  def change
    add_column :compatibility_searches, :max_score, :integer
    add_column :compatibility_searches, :grouped_count, :integer
    add_column :compatibility_searches, :above_threshold_count, :integer
    add_column :check_searches, :max_score, :integer
    add_column :check_searches, :grouped_count, :integer
    add_column :check_searches, :above_threshold_count, :integer
  end
end
