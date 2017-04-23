class UpdateSearchRecordsToVersion3 < ActiveRecord::Migration
  def change
    update_view :search_records, version: 3, revert_to_version: 2
  end
end
