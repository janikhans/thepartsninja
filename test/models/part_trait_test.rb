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

  test "fixtures should be valid" do
    assert @wheel06location.valid?
    assert @wheel05location.valid?
    assert @wheel08location.valid?
    assert @wheel15location.valid?
    assert @speedowheel17wrlocation.valid?
    assert @wheel06rim_size.valid?
    assert @wheel05rim_size.valid?
    assert @wheel08rim_size.valid?
    assert @wheel15rim_size.valid?
    assert @speedowheel17wrrim_size.valid?
    assert @brakepadslocation.valid?
  end

  # TODO tests for sanitization
end
