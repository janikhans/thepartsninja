class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :email, null: false, index: true
      t.boolean :auto
      t.boolean :streetbike
      t.boolean :dirbike
      t.boolean :dualsport
      t.boolean :atv
      t.boolean :utv
      t.boolean :snowmobile
      t.boolean :watercraft

      t.timestamps null: false
    end
  end
end
