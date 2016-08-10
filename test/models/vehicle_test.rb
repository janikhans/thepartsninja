require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  should belong_to(:vehicle_year)
  # should validate_presence_of(:vehicle_year)
  should belong_to(:vehicle_submodel)
  # should validate_presence_of(:vehicle_submodel)
  should have_many(:searches)
  should have_many(:fitments).dependent(:destroy)
  should have_many(:oem_parts).through(:fitments).source(:part)

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

  test "VehicleForm should integer or string year attribute" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)
    assert vehicle.valid?

    vehicle.year = "2008"
    assert vehicle.valid?
  end

  test "VehicleForm should create new vehicle and association" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)
    assert vehicle.valid?

    assert_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count", "Vehicle.count"] do
      vehicle.save
    end

    new_vehicle = vehicle.vehicle
    assert_equal new_vehicle.brand.name, "Kawasaki"
  end

  test "VehicleForm should select brand, model and nil submodel if no name is given" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)
    assert vehicle.valid?
    vehicle.save
    vehicle_count = Vehicle.count

    new_vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2015)
    assert new_vehicle.valid?

    assert_no_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count"] do
      new_vehicle.save
    end
    assert_equal Vehicle.count, vehicle_count + 1
  end

  test "VehicleForm should select brand, model and create submodel if name is given" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)
    assert vehicle.valid?
    vehicle.save

    new_vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", submodel: "Test", year: 2015)
    assert new_vehicle.valid?

    assert_difference ["Vehicle.count", "VehicleSubmodel.count"] do
      new_vehicle.save
    end
  end

  test "VehicleForm should return vehicle if already exists" do
    vehicle = VehicleForm.new(brand: "Yamaha", model: "YZ250", type: "Motorcycle", year: 2006)
    assert vehicle.valid?
    vehicle.save

    assert_no_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count", "Vehicle.count"] do
      vehicle.save
    end

    assert_equal vehicle.vehicle, vehicles(:yz250)
  end
end
