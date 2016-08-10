require 'test_helper'

class VehicleSubmodelTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:name).scoped_to(:vehicle_model_id)
  should have_many(:vehicles).dependent(:destroy)
  should belong_to(:vehicle_model)
  should validate_presence_of(:vehicle_model)

  setup do
    @yz250 = vehicle_submodels(:yz250)
    @yz125 = vehicle_submodels(:yz125)
    @f150 = vehicle_submodels(:f150)
    @te300 = vehicle_submodels(:te300)
    @lariat = vehicle_submodels(:lariat)
    @yz450 = vehicle_submodels(:yz450)
    @wr250 = vehicle_submodels(:wr250)
  end

  test "fixtures should be valid" do
    assert @yz250.valid?
    assert @yz125.valid?
    assert @f150.valid?
    assert @te300.valid?
    assert @lariat.valid?
    assert @wr250.valid?
    assert @yz450.valid?
  end

  test "vehicle submodel should be unique on name and vehicle_model_id" do
    new_submodel = VehicleSubmodel.new(vehicle_model: vehicle_models(:f150))
    existing_submodel_name = @lariat.name
    assert_equal existing_submodel_name, "Lariat"

    assert new_submodel.valid?

    new_submodel.name = existing_submodel_name
    assert_not new_submodel.valid?

    new_submodel.name = existing_submodel_name.downcase
    assert_not new_submodel.valid?
  end

  test "name should be sanitized with capital first letter, remaining unchanged" do
    new_submodel = VehicleSubmodel.new(vehicle_model: vehicle_models(:f150), name: nil)

    new_submodel.name = "TEST"
    new_submodel.save
    assert new_submodel.name = "TEST"

    new_submodel.name = "tESt"
    new_submodel.save
    assert new_submodel.name = "TESt"

    new_submodel.name = "test"
    new_submodel.save
    assert new_submodel.name = "Test"
  end
end
