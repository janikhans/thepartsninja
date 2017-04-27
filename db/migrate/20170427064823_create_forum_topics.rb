class CreateForumTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_topics do |t|
      t.string :title, null: false
      t.string :slug

      t.timestamps
    end
    add_index :forum_topics, :slug, unique: true
  end
end
