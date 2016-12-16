require 'test_helper'

class NinjaCategoryTest < UnitTest
  should have_many(:subcategories).dependent(:destroy)
  should have_many(:products).dependent(:restrict_with_error)
  should have_many(:product_types).dependent(:destroy)
end
