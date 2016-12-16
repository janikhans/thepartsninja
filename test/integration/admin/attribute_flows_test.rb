require 'test_helper'

class Admin::AttributeFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "should open index page" do
    sign_in(@user)
    visit admin_attributes_path

    assert has_text? "General Attributes"
  end
end
