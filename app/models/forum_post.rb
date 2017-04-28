class ForumPost < ApplicationRecord
  belongs_to :forum_thread, counter_cache: true
  validates :forum_thread, presence: true

  belongs_to :user
  validates :user, presence: true

  validates :body, presence: true

  before_save :add_forum_topic_post_count
  before_destroy :subtract_forum_topic_post_count

  def add_forum_topic_post_count
    topic = ForumTopic.find(forum_thread.forum_topic_id)
    topic.forum_posts_count += 1
    topic.save
  end

  def subtract_forum_topic_post_count
    topic = ForumTopic.find(forum_thread.forum_topic_id)
    topic.forum_posts_count -= 1
    topic.save
  end
end
