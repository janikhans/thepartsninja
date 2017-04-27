require 'test_helper'

class ForumThreadTest < ActiveSupport::TestCase
  should validate_presence_of(:forum_topic)
  should belong_to(:forum_topic)

  should validate_presence_of(:author)
  should belong_to(:author).class_name('User')

  should have_many(:forum_posts).dependent(:destroy)
end
