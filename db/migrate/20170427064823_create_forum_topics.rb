class CreateForumTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_topics do |t|
      t.string :title, null: false
      t.text :description
      t.string :icon
      t.integer :forum_threads_count, default: 0
      t.integer :forum_posts_count, default: 0
      t.boolean :private, default: false
      t.string :slug
      t.string :ancestry

      t.timestamps
    end
    add_index :forum_topics, :slug, unique: true
    add_index :forum_topics, :ancestry
  end
end
