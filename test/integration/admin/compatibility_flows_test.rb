require 'test_helper'

class Admin::CompatibilityFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_compatibilities_path

    assert has_text? "Compatibilities"
  end

  # TODO create new compatibility test
  # test "should create new compatibility" do
  #   visit admin_compatibilities_path
  # end

  test "should show a compatibilities page" do
    compatibility = compatibilities(:one)
    visit admin_compatibility_path(compatibility)
  end

  # test "should show errors on new brand" do
  #   # currently not setup correctly
  # end

  test "should edit brand" do
    compatibility = compatibilities(:one)
    visit edit_admin_compatibility_path(compatibility)
  end

  # test "should destroy compatibility" do
  #
  # end
end
