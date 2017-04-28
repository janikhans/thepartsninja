class CreateForumThreads < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_threads do |t|
      t.references :forum_topic, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.string :slug
      t.boolean :sticky, default: false
      t.boolean :locked, default: false
      t.integer :forum_posts_count, default: 0

      t.timestamps
    end
    add_index :forum_threads, :slug, unique: true
  end
end
