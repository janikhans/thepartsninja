require 'test_helper'

class ProductTypeTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).scoped_to(:category_id)
  should belong_to(:category)
  should validate_presence_of(:category)
  should have_many(:products)
end
