class CreateForumThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_threads do |t|
      t.references :forum_topic, foreign_key: true, null: false
      t.integer :author_id, index: true, foreign_key: true, null: false
      t.string :subject, null: false
      t.string :slug

      t.timestamps
    end
    add_index :forum_threads, :slug, unique: true
  end
end
