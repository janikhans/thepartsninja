require 'test_helper'

class Admin::StatisticsFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  # FIXME there's an issue with floor on line 36
  # test "should open index page" do
  #   visit admin_root_path
  #
  #   assert has_text? "Dashboard"
  #   # TODO should show correct information
  # end
end
