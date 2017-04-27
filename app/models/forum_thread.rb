class ForumThread < ApplicationRecord
  extend FriendlyId
  friendly_id :subject, use: [:finders, :slugged]

  belongs_to :author, class_name: 'User'
  validates :author, presence: true

  has_many :forum_posts, dependent: :destroy
end
