class CreateForumPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :forum_posts do |t|
      t.references :forum_thread, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
