require 'test_helper'

class PartAttributeTest < UnitTest
  should validate_presence_of(:name)
  # should validate_uniqueness_of(:name).scoped_to(:parent_id)
  should have_many(:attribute_variations).dependent(:destroy)
  should have_many(:part_attributions).dependent(:destroy)

  setup do
    @new_part_attribute = PartAttribute.new(name: "Test")
    @location = part_attributes(:location)
    @rim_size = part_attributes(:rim_size)
    @front = part_attributes(:front)
    @rear = part_attributes(:rear)
    @rim19 = part_attributes(:rim19)
    @rim21 = part_attributes(:rim21)
    @rim18 = part_attributes(:rim18)
  end
  # TODO tests for scopes
end
