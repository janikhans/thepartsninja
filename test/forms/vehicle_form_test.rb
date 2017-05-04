require 'test_helper'

class VehicleFormTest < UnitTest
  should validate_presence_of(:vehicle_brand)
  should validate_presence_of(:vehicle_model)
  should validate_presence_of(:vehicle_type)

  setup do
    @vehicle = VehicleForm.new(vehicle_brand: "Kawasaki", vehicle_model: "KX450F", vehicle_type: "Motorcycle", vehicle_year: 2008)
  end

  test "VehicleForm should accept integer or string year" do
    vehicle = @vehicle
    assert vehicle.valid?

    vehicle.vehicle_year = "2008"
    assert vehicle.valid?
  end

  test "form should only allow certain vehicle_types" do
    vehicle = @vehicle
    vehicle.vehicle_type = "Bad Type"
    assert_not vehicle.valid?
  end

  test "VehicleForm should create new vehicle and associations if none exist" do
    vehicle = @vehicle
    assert vehicle.valid?

    assert_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count", "Vehicle.count"] do
      vehicle.find_or_create
    end

    new_vehicle = vehicle.vehicle
    assert_equal new_vehicle.brand.name, "Kawasaki"
  end

  test "VehicleForm should select brand, model and nil submodel if no name is given" do
    vehicle = @vehicle
    assert vehicle.valid?
    vehicle.find_or_create
    vehicle_count = Vehicle.count

    new_vehicle = VehicleForm.new(vehicle_brand: "Kawasaki", vehicle_model: "KX450F", vehicle_type: "Motorcycle", vehicle_year: 2015)
    assert new_vehicle.valid?

    assert_no_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count"] do
      new_vehicle.find_or_create
    end
    assert_equal Vehicle.count, vehicle_count + 1
  end

  test "VehicleForm should select brand, model and create submodel if name is given" do
    vehicle = @vehicle
    assert vehicle.valid?
    vehicle.find_or_create

    new_vehicle = VehicleForm.new(vehicle_brand: "Kawasaki", vehicle_model: "KX450F", vehicle_type: "Motorcycle", vehicle_submodel: "Test", vehicle_year: 2015)
    assert new_vehicle.valid?

    assert_difference ["Vehicle.count", "VehicleSubmodel.count"] do
      new_vehicle.find_or_create
    end
  end

  test "VehicleForm should select brand, model and select submodel if name is given" do
    vehicle = VehicleForm.new(vehicle_brand: "Kawasaki", vehicle_model: "KX450F", vehicle_type: "Motorcycle", vehicle_submodel: "Test", vehicle_year: 2008)
    assert vehicle.valid?
    vehicle.find_or_create

    new_vehicle = VehicleForm.new(vehicle_brand: "Kawasaki", vehicle_model: "KX450F", vehicle_type: "Motorcycle", vehicle_submodel: "Test", vehicle_year: 2015)
    assert new_vehicle.valid?

    assert_difference ["Vehicle.count"] do
      new_vehicle.find_or_create
    end
  end

  test "VehicleForm should return vehicle if already exists" do
    vehicle = VehicleForm.new(vehicle_brand: "Yamaha", vehicle_model: "YZ250", vehicle_type: "Motorcycle", vehicle_year: 2006)
    assert vehicle.valid?
    vehicle.find_or_create

    assert_no_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count", "Vehicle.count"] do
      vehicle.find_or_create
    end

    assert_equal vehicle.vehicle, vehicles(:yz250)
  end

  # test "VehicleForm should set epid if given" do
  #   vehicle = @vehicle
  #   vehicle.epid = 123456
  #   assert vehicle.valid?
  #
  #   vehicle.find_or_create
  #   assert_equal vehicle.epid, 123456
  #
  #   new_vehicle = VehicleForm.new(brand: "Yamaha", model: "YZ250", type: "Motorcycle", year: 2015, epid: "987654")
  #   new_vehicle.find_or_create
  #   assert_equal new_vehicle.epid, 987654
  # end
  #
  # test "VehicleForm should be invalid if epid already exits" do
  #   vehicle = @vehicle
  #   vehicle.epid = 123456
  #   assert vehicle.valid?
  #
  #   vehicle.find_or_create
  #   assert_equal vehicle.epid, 123456
  #
  #   new_vehicle = VehicleForm.new(brand: "Existing Epid", model: "Example", type: "Motorcycle", year: 2015, epid: "123456")
  #   assert_not new_vehicle.valid?
  # end

  # TODO test sanitization
end
