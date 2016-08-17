require 'test_helper'

class FitmentTest < UnitTest
  should validate_presence_of(:vehicle)
  should belong_to(:vehicle)
  should validate_presence_of(:part)
  should validate_uniqueness_of(:part).scoped_to(:vehicle_id)
  should belong_to(:part)
  should belong_to(:user)
  should belong_to(:discovery)

  setup do
    @wheel06yz250 = fitments(:wheel06yz250)
    @wheel06yz125 = fitments(:wheel06yz125)
    @wheel05yz125 = fitments(:wheel05yz125)
    @wheel08yz250 = fitments(:wheel08yz250)
    @wheel15yz450 = fitments(:wheel15yz450)
    @brakepadste300 = fitments(:brakepadste300)
    @speedowheel17wr250 = fitments(:speedowheel17wr250)
  end
end
