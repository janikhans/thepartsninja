require 'test_helper'

class CheckSearchTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:category)
  should belong_to(:vehicle_one)
  should belong_to(:vehicle_two)
  should validate_presence_of(:vehicle_one)
  should validate_presence_of(:vehicle_two)
  should validate_presence_of(:category_name)
end
