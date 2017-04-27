require 'test_helper'

class ForumPostTest < ActiveSupport::TestCase
  should validate_presence_of(:forum_thread)
  should belong_to(:forum_thread)

  should validate_presence_of(:user)
  should belong_to(:user)

  should validate_presence_of(:body)
end
