class CreateDiscussions < ActiveRecord::Migration[5.0]
  def change
    create_table :discussions do |t|
      t.integer :author_id, index: true, foreign_key: true, null: false

      t.timestamps
    end
  end
end
