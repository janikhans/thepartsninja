class CreateImportErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :import_errors do |t|
      t.string :type, null: false
      t.text :row, null: false
      t.text :import_errors, null: false

      t.timestamps
    end
  end
end
