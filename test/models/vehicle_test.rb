require 'test_helper'

class VehicleTest < UnitTest
  should belong_to(:vehicle_year)
  # should validate_presence_of(:vehicle_year)
  should belong_to(:vehicle_submodel)
  # should validate_presence_of(:vehicle_submodel)
  should have_many(:searches)
  should have_many(:fitments).dependent(:destroy)
  should have_many(:oem_parts).through(:fitments).source(:part)

  setup do
    @yz250 = vehicles(:yz250)
    @yz25008 = vehicles(:yz25008)
    @yz125 = vehicles(:yz125)
    @yz12506 = vehicles(:yz12506)
    @f150 = vehicles(:f150)
    @te300 = vehicles(:te300)
    @lariat = vehicles(:lariat)
    @yz450 = vehicles(:yz450)
    @wr250 = vehicles(:wr250)
  end

  test "methods should show a vehicles associated attributes" do
    vehicle = @yz250
    lariat = @lariat

    assert_equal vehicle.brand, brands(:yamaha)
    assert_equal vehicle.model, vehicle_models(:yz250)
    assert_equal vehicle.submodel, vehicle_submodels(:yz250)
    assert_equal vehicle.year, "2006"
    assert_equal vehicle.submodel_name, nil
    assert_equal vehicle.to_label, "2006 Yamaha YZ250"

    assert_equal lariat.to_label, "2017 FORD F150 Lariat"
  end

  test "slug for url should be friendly" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)

    assert vehicle.valid?
    vehicle.save

    assert_equal vehicle.vehicle.slug, "2008-kawasaki-kx450f"

    new_vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", submodel: "Test", year: 2008)
    assert new_vehicle.valid?
    new_vehicle.save

    assert_equal new_vehicle.vehicle.slug, "2008-kawasaki-kx450f-test"
  end
end
