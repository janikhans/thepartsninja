require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  should belong_to(:vehicle_year)
  should validate_presence_of(:vehicle_year)

  should belong_to(:vehicle_submodel)
  should validate_presence_of(:vehicle_submodel)

  setup do
    @yz250 = vehicles(:yz250)
    @yz125 = vehicles(:yz125)
    @f150 = vehicles(:f150)
    @te300 = vehicles(:te300)
    @lariat = vehicles(:lariat)
  end

  test "fixtures should be valid" do
    assert @yz250.valid?
    assert @yz125.valid?
    assert @f150.valid?
    assert @te300.valid?
    assert @lariat.valid?
  end
end
