require 'test_helper'

class Admin::UserFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_users_path

    assert has_text? "Users"
  end

  # test "should invite new user" do
  #   visit admin_users_path
  #   user_email = "test@test.com"
  #
  #   fill_in "user_email", with: user_email
  #   click_on "Send an invitation"
  # end

  test "should show a users page" do
    user = users(:janik)
    visit admin_user_path(user)
    assert has_text? user.username
  end

  # test "should show errors on new user" do
  #   # currently not setup correctly
  # end

  test "should edit user" do
    user = users(:janik)
    visit edit_admin_user_path(user)
  end

  # test "should destroy user" do
  #
  # end
end
