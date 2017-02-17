require 'test_helper'

class SearchRecordTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:vehicle)
  should belong_to(:comparing_vehicle)
  should belong_to(:searchable)
  should belong_to(:category)
end
