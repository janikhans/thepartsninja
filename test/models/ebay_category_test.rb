require 'test_helper'

class EbayCategoryTest < UnitTest
  should have_many(:subcategories).dependent(:destroy)
  should have_many(:products).dependent(:restrict_with_error)
end
