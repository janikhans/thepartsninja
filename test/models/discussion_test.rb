require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  should validate_presence_of(:author)
  should belong_to(:author).class_name('User')
end
