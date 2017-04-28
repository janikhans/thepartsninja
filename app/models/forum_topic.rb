class ForumTopic < ApplicationRecord
  has_ancestry

  extend FriendlyId
  friendly_id :title, use: [:finders, :slugged]

  scope :available, -> { where(private: false) }

  validates :title, presence: true

  has_many :forum_threads, dependent: :destroy
  has_many :forum_posts, through: :forum_threads

  has_one :last_forum_thread,
    -> { order created_at: :desc },
    class_name: 'ForumThread'

  has_one :last_forum_post,
    through: :last_forum_thread,
    source: :forum_posts
end
