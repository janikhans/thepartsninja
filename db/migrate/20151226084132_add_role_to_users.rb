class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: "user", null: false
  end
end
