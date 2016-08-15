require 'test_helper'

class VehicleYearTest < UnitTest
  # assert_all_fixtures_valid(VehicleYear)
  # find_all_invalid_fixtures

  should validate_presence_of(:year)
  should validate_uniqueness_of(:year)
  should validate_numericality_of(:year)
  should have_many(:vehicles).dependent(:restrict_with_error)

  setup do
    @year05 = vehicle_years(:year05)
    @year06 = vehicle_years(:year06)
    @year08 = vehicle_years(:year08)
    @year15 = vehicle_years(:year15)
    @year16 = vehicle_years(:year16)
    @year17 = vehicle_years(:year17)
  end

  test "fixtures should be valid" do
    assert @year05.valid?
    assert @year06.valid?
    assert @year08.valid?
    assert @year15.valid?
    assert @year16.valid?
    assert @year17.valid?
  end

end
