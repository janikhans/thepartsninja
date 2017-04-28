class ForumThread < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:finders, :slugged]

  belongs_to :forum_topic, counter_cache: true
  validates :forum_topic, presence: true

  belongs_to :user
  validates :user, presence: true

  has_many :forum_posts, dependent: :destroy

  has_one :last_forum_post,
    -> { order created_at: :desc },
    class_name: 'ForumPost'

  validates :title, presence: true
  validates :body, presence: true
end
