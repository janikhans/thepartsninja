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
    @new_part = Part.new(product: products(:wheel), part_number: "1234", note: "More test info")
    @wheel06yz = parts(:wheel06yz)
    @wheel05yz = parts(:wheel05yz)
    @wheel08yz = parts(:wheel08yz)
    @wheel15yz = parts(:wheel15yz)
    @brakepadste300 = parts(:brakepadste300)
    @speedowheel17wr = parts(:speedowheel17wr)
  end

  test "fixtures should be valid" do
    assert @wheel06yz.valid?
    assert @wheel05yz.valid?
    assert @wheel08yz.valid?
    assert @wheel15yz.valid?
    assert @brakepadste300.valid?
    assert @speedowheel17wr.valid?
  end
end
