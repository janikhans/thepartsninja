require 'test_helper'

class Admin::LeadFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_leads_path

    assert has_text? "Leads"
  end

  # test "should destroy lead" do
  #   visit admin_leads_path
  #
  # end
end
