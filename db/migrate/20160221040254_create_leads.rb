class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :email, null: false
      t.boolean :auto
      t.boolean :streetbike
      t.boolean :dirtbike
      t.boolean :atv
      t.boolean :utv
      t.boolean :watercraft
      t.boolean :snowmobile
      t.boolean :dualsport

      t.timestamps null: false
    end
  end
end
