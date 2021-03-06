require 'test_helper'

class LeadTest < UnitTest
  should validate_presence_of(:email)
  should validate_length_of(:email).is_at_most(255)

  setup do
    @one = leads(:one)
    @two = leads(:two)
    @three = leads(:three)
  end
end
