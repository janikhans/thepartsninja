require 'test_helper'

class PartAttributionTest < UnitTest
  should validate_presence_of(:part)
  should belong_to(:part)
  should validate_presence_of(:part_attribute)
  should validate_uniqueness_of(:part_attribute).scoped_to(:part_id)
  should belong_to(:part_attribute)

  setup do
    @wheel06location = part_attributions(:wheel05location)
    @wheel05location = part_attributions(:wheel06location)
    @wheel08location = part_attributions(:wheel08location)
    @wheel15location = part_attributions(:wheel15location)
    @speedowheel17wrlocation = part_attributions(:speedowheel17wrlocation)
    @wheel06rim_size = part_attributions(:wheel06rim_size)
    @wheel05rim_size = part_attributions(:wheel05rim_size)
    @wheel08rim_size = part_attributions(:wheel08rim_size)
    @wheel15rim_size = part_attributions(:wheel15rim_size)
    @speedowheel17wrrim_size = part_attributions(:speedowheel17wrrim_size)
    @brakepadslocation = part_attributions(:brakepadslocation)
  end
  # TODO tests for sanitization
end
