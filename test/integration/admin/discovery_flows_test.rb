require 'test_helper'

class Admin::DiscoveryFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_discoveries_path

    assert has_text? "Discoveries"
  end

  test "should show a discoveries page" do
    discovery = discoveries(:one)
    visit admin_discovery_path(discovery)
  end

  test "should edit discovery" do
    discovery = discoveries(:one)
    visit edit_admin_discovery_path(discovery)
  end

  # test "should destroy discovery" do
  #
  # end
end
