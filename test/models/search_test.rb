require 'test_helper'

class SearchTest < UnitTest
  should belong_to(:user)
  should belong_to(:vehicle)

  setup do
    @one = searches(:one)
    @two = searches(:two)
    @three = searches(:three)
    @four = searches(:four)
  end
end
