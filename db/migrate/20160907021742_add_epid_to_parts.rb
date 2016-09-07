class AddEpidToParts < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :epid, :integer, index: true
  end
end
