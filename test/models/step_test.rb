require 'test_helper'

class StepTest < UnitTest
  should validate_presence_of(:discovery)
  should belong_to(:discovery)
  should validate_presence_of(:content)

  setup do
    @one = steps(:one)
    @two = steps(:two)
    @three = steps(:three)
  end
end
