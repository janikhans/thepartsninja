require 'test_helper'

class PartTest < ActiveSupport::TestCase
  should validate_presence_of(:product)
  # should validate_uniqueness_of(:part_number).scoped_to(:product_id)
  should belong_to(:product)
  should belong_to(:user)
  should have_many(:fitments)
  should have_many(:oem_vehicles).through(:fitments).source(:vehicle)
  should have_many(:part_traits).dependent(:destroy)
  should have_many(:part_attributes).through(:part_traits).source(:part_attribute)
  should have_many(:compatibles).dependent(:destroy)
  should accept_nested_attributes_for(:part_traits)

  setup do
    @new_category = Category.new(name: "Test")
    @wheels = categories(:wheels)
    @bearings = categories(:bearings)
    @body = categories(:body)
    @brakes = categories(:brakes)
    @wheel_assembly = categories(:wheel_assembly)
    @wheel_bearings = categories(:wheel_bearings)
    @brake_pads = categories(:brake_pads)
  end

  test "fixtures should be valid" do
    assert @wheels.valid?
    assert @bearings.valid?
    assert @body.valid?
    assert @brakes.valid?
    assert @wheel_assembly.valid?
    assert @wheel_bearings.valid?
    assert @brake_pads.valid?
  end
end
