class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, null: false, default: ""
      t.string :website

      t.timestamps null: false
    end
  end
end
