require 'test_helper'

class ImportErrorTest < UnitTest
  should validate_presence_of(:row)
  should validate_presence_of(:import_errors)
end
