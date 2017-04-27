class ForumPost < ApplicationRecord
  belongs_to :forum_thread
  validates :forum_thread, presence: true

  belongs_to :user
  validates :user, presence: true

  validates :body, presence: true
end
