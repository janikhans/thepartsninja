require 'test_helper'

class StepTest < ActiveSupport::TestCase
  should validate_presence_of(:discovery)
  should belong_to(:discovery)
  should validate_presence_of(:content)

  setup do
    @one = steps(:one)
    @two = steps(:two)
    @three = steps(:three)
  end

  test "fixtures should be valid" do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
  end

end
