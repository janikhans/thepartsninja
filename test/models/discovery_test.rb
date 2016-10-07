require 'test_helper'

class DiscoveryTest < UnitTest
  should validate_presence_of(:user)
  should belong_to(:user)
  should have_many(:compatibilities).dependent(:destroy)
  should have_many(:steps).dependent(:destroy)
  should accept_nested_attributes_for(:steps)

  # TODO are these even neccessary?
  should accept_nested_attributes_for(:compatibilities)
  should have_many(:parts).through(:compatibilities).source(:part)
  should have_many(:compatible_parts).through(:compatibilities).source(:compatible_part)


  setup do
    @one = discoveries(:one)
    @two = discoveries(:two)
    @three = discoveries(:three)
    @four = discoveries(:four)
    @five = discoveries(:five)
  end
end
