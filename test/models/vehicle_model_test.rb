require 'test_helper'

class VehicleModelTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).scoped_to(:brand_id)
  should have_many(:vehicle_submodels).dependent(:destroy)
  should have_many(:vehicles).through(:vehicle_submodels)
  should belong_to(:brand)
  should validate_presence_of(:brand)
  should belong_to(:vehicle_type)
  should validate_presence_of(:vehicle_type)

  setup do
    @new_model = VehicleModel.new(brand: brands(:yamaha), name: "Test", vehicle_type: vehicle_types(:motorcycle))
    @yz250 = vehicle_models(:yz250)
    @yz125 = vehicle_models(:yz125)
    @f150 = vehicle_models(:f150)
    @te300 = vehicle_models(:te300)
    @yz450 = vehicle_models(:yz450)
    @wr250 = vehicle_models(:wr250)
  end

  test "fixtures should be valid" do
    assert @yz250.valid?
    assert @yz125.valid?
    assert @f150.valid?
    assert @te300.valid?
    assert @yz450.valid?
    assert @wr250.valid?
  end

  test "vehicle model should be unique on name and brand_id" do
    new_model = @new_model
    existing_model_name = @yz250.name
    assert_equal existing_model_name, "YZ250"

    assert new_model.valid?

    new_model.name = existing_model_name
    assert_not new_model.valid?

    new_model.name = existing_model_name.downcase
    assert_not new_model.valid?
  end

  test "name should be sanitized with capital first letter, remaining unchanged" do
    new_model = @new_model

    new_model.name = "TEST"
    new_model.save
    assert new_model.name = "TEST"

    new_model.name = "tESt"
    new_model.save
    assert new_model.name = "TESt"

    new_model.name = "test"
    new_model.save
    assert new_model.name = "Test"
  end
end
