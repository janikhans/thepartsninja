require 'test_helper'

class CompatibilitySearchTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:vehicle)
  should belong_to(:category)
  should validate_presence_of(:vehicle)
  should validate_presence_of(:category_name)
end
