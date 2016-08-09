require 'test_helper'

class VehicleTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should have_many(:vehicle_models)

  setup do
    @motorcycle = vehicle_types(:motorcycle)
    @utv = vehicle_types(:utv)
    @snowmobile = vehicle_types(:snowmobile)
    @scooter = vehicle_types(:scooter)
    @pwc = vehicle_types(:pwc)
    @truck = vehicle_types(:truck)
  end

  test "fixtures should be valid" do
    assert @motorcycle.valid?
    assert @utv.valid?
    assert @snowmobile.valid?
    assert @scooter.valid?
    assert @pwc.valid?
    assert @truck.valid?
  end
end
