require 'test_helper'

class CategoryTest < UnitTest
  should validate_presence_of(:name)
  # should validate_uniqueness_of(:name).scoped_to(:parent_id)
  should have_many(:subcategories).dependent(:destroy)
  should have_many(:products).dependent(:restrict_with_error)
  should have_many(:product_types).dependent(:destroy)

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

  # TODO fix validation above on uniquness scope
  # tests to check for sanitization methods
  # users will probably have to create some of these types so look into that
end
