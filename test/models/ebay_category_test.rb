require 'test_helper'

class EbayCategoryTest < UnitTest
  should have_many(:products).dependent(:restrict_with_error)
  should validate_presence_of(:name)
end
