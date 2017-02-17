class CreateSearchRecords < ActiveRecord::Migration
  def change
    create_view :search_records
  end
end
