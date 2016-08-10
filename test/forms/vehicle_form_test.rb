require 'test_helper'

class VehicleFormTest < ActiveSupport::TestCase
  should validate_presence_of(:brand)
  should validate_presence_of(:model)
  should validate_presence_of(:type)
  should validate_presence_of(:year)

  setup do
    @vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", year: 2008)
  end

  test "VehicleForm should accept integer or string year attribute" do
    vehicle = @vehicle
    assert vehicle.valid?

    vehicle.year = "2008"
    assert vehicle.valid?
  end

  test "VehicleForm should create new vehicle and associations if none exist" do
    vehicle = @vehicle
    assert vehicle.valid?

    assert_difference ["Brand.count", "VehicleModel.count", "VehicleSubmodel.count", "Vehicle.count"] do
      vehicle.save
    end

    new_vehicle = vehicle.vehicle
    assert_equal new_vehicle.brand.name, "Kawasaki"
  end

  test "VehicleForm should select brand, model and nil submodel if no name is given" do
    vehicle = @vehicle
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
    vehicle = @vehicle
    assert vehicle.valid?
    vehicle.save

    new_vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", submodel: "Test", year: 2015)
    assert new_vehicle.valid?

    assert_difference ["Vehicle.count", "VehicleSubmodel.count"] do
      new_vehicle.save
    end
  end

  test "VehicleForm should select brand, model and select submodel if name is given" do
    vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", submodel: "Test", year: 2008)
    assert vehicle.valid?
    vehicle.save

    new_vehicle = VehicleForm.new(brand: "Kawasaki", model: "KX450F", type: "Motorcycle", submodel: "Test", year: 2015)
    assert new_vehicle.valid?

    assert_difference ["Vehicle.count"] do
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

  # TODO test sanitization
end
