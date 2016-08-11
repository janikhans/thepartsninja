require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:vehicle)

  setup do
    @one = searches(:one)
    @two = searches(:two)
    @three = searches(:three)
    @four = searches(:four)
  end

  test "fixtures should be valid" do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
    assert @four.valid?
  end
end
