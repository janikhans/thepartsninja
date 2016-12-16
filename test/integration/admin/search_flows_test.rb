require 'test_helper'

class Admin::SearchFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test "should open index page" do
    visit admin_searches_path

    assert has_text? "Searches"
  end

  # test "should destroy search" do
  #
  # end
end
