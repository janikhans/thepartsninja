require 'test_helper'

class LeadTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should validate_length_of(:email).is_at_most(255)

  setup do
    @one = leads(:one)
    @two = leads(:two)
    @three = leads(:three)
  end

  test "fixtures should be valid" do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
  end
end
