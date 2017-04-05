require 'test_helper'

class PageFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
  end

  test "terms should be visible to everyone" do
    visit root_url
    click_on "Legal"
    assert has_text? "Terms of Service"

    sign_in(@user)
    click_on "Legal"
    assert has_text? "Terms of Service"
  end

  test "privacy should be visible to everyone" do
    visit root_url
    click_on "Privacy"
    assert has_text? "Privacy Policy"

    sign_in(@user)
    click_on "Privacy"
    assert has_text? "Privacy Policy"
  end

  test "other pages should be visible only to logged in users" do
    visit help_pages_path
    assert has_text? "You need to sign in or sign up before continuing."

    visit about_pages_path
    assert has_text? "You need to sign in or sign up before continuing."

    visit search_pages_path
    assert has_text? "You need to sign in or sign up before continuing."

    visit contact_pages_path
    assert has_text? "You need to sign in or sign up before continuing."
  end
end
