class ForumTopic < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:finders, :slugged]

  validates :title, presence: true

  has_many :forum_threads, dependent: :destroy
  has_many :forum_posts, through: :forum_threads
end
