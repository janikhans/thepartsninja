require 'test_helper'

class LayoutFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    # login_as(@user, scope: :user)
    sign_in(@user)
  end

  test "footer should show links important links" do
    visit root_url

    within "footer" do
      assert has_link? "Privacy Policy"
      assert has_link? "Terms & Conditions"
      assert has_link? "Home"
      assert has_link? "Contact Us"
    end
  end

  test "should show sign-up and sign-in links if not signed-in" do
    visit root_url
    assert has_link? "Sign Out"

    sign_out
    assert has_link? "Login"
    # assert has_link "Sign Up"
  end

  test "signed-out users should not see protected links" do
    logout(:user)
    visit root_url
    refute has_link? "New Discovery"
    refute has_link? "Dashboard"
    refute has_link? "Vehicles"
    refute has_link? "Brands"
  end

  test "Admin portal link should only be visible to Admins" do
    visit root_url
    assert @user.admin?
    assert has_link? "Admin"
    sign_out

    new_user = users(:hans)
    sign_in(new_user)
    refute new_user.admin?
    refute has_link? "Admin"
  end
end
