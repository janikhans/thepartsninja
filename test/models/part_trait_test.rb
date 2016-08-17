require 'test_helper'

class PartTraitTest < UnitTest
  should validate_presence_of(:part)
  should belong_to(:part)
  should validate_presence_of(:part_attribute)
  should validate_uniqueness_of(:part_attribute).scoped_to(:part_id)
  should belong_to(:part_attribute)

  setup do
    @wheel06location = part_traits(:wheel05location)
    @wheel05location = part_traits(:wheel06location)
    @wheel08location = part_traits(:wheel08location)
    @wheel15location = part_traits(:wheel15location)
    @speedowheel17wrlocation = part_traits(:speedowheel17wrlocation)
    @wheel06rim_size = part_traits(:wheel06rim_size)
    @wheel05rim_size = part_traits(:wheel05rim_size)
    @wheel08rim_size = part_traits(:wheel08rim_size)
    @wheel15rim_size = part_traits(:wheel15rim_size)
    @speedowheel17wrrim_size = part_traits(:speedowheel17wrrim_size)
    @brakepadslocation = part_traits(:brakepadslocation)
  end
  # TODO tests for sanitization
end
