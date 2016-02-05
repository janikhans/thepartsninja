class AddCachedScoreToCompatibles < ActiveRecord::Migration
  def self.up
    add_column :compatibles, :cached_votes_score, :integer, :default => 0
    add_index  :compatibles, :cached_votes_score

    # Uncomment this line to force caching of existing votes
    # Compatible.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :compatibles, :cached_votes_score
  end
end
