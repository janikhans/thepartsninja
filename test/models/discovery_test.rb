require 'test_helper'

class DiscoveryTest < ActiveSupport::TestCase
  should validate_presence_of(:user)
  should belong_to(:user)
  should have_many(:compatibles).dependent(:destroy)
  should have_many(:steps).dependent(:destroy)
  should accept_nested_attributes_for(:steps)

  # TODO are these even neccessary?
  should accept_nested_attributes_for(:compatibles)
  should have_many(:parts).through(:compatibles).source(:part)
  should have_many(:compatible_parts).through(:compatibles).source(:compatible_part)


  setup do
    @one = discoveries(:one)
    @two = discoveries(:two)
    @three = discoveries(:three)
    @four = discoveries(:four)
    @five = discoveries(:five)
  end

  test "fixtures should be valid" do
    assert @one.valid?
    assert @two.valid?
    assert @three.valid?
    assert @four.valid?
    assert @five.valid?
  end
end
