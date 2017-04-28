require 'test_helper'

class Forum::ForumFlowsTest < IntegrationTest
  test 'forums should only be open to logged in users' do
    visit forum_root_path
    assert has_css? '.alert',
      text: 'You need to sign in or sign up before continuing.'

    user = users(:janik)
    sign_in(user)
    visit forum_root_path
    assert has_text? 'Forum'
  end
end
