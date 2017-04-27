require 'test_helper'

class ForumTopicTest < ActiveSupport::TestCase
  should validate_presence_of(:title)

  should have_many(:forum_threads).dependent(:destroy)
end
