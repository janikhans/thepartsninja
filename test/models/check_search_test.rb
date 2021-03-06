require 'test_helper'

class CheckSearchTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:category)
  should belong_to(:vehicle)
  should belong_to(:comparing_vehicle)
  should validate_presence_of(:vehicle)
  should validate_presence_of(:comparing_vehicle)
  should validate_presence_of(:category_name)
end
