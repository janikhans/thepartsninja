require 'test_helper'

class Forum::ForumTopicFlowsTest < IntegrationTest
  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test 'should show forum index page' do
    visit forum_root_path
    assert has_text? 'Forum'
  end

  test 'should show a forum topic page' do
    topic = forum_topics(:feedback)

    visit forum_root_path
    assert has_text? 'Forum'
    click_on topic.title

    assert has_text? topic.title
    assert has_text? topic.description
  end

  test 'should not show private forums in index' do
    private_topic = ForumTopic.where(private: true).first

    visit forum_root_path
    assert has_no_text? private_topic.title

    private_topic.update_attribute(:private, false)

    visit forum_root_path
    assert has_text? private_topic.title
  end
end
