require 'test_helper'

class Admin::ForumTopicFlowsTest < IntegrationTest

  setup do
    @user = users(:janik)
    sign_in(@user)
  end

  test 'should open index page' do
    visit admin_forum_topics_path

    assert has_text? 'Forum Topics'
  end

  test 'should create new parent forum topic' do
    visit admin_forum_topics_path
    forum_topic_title = 'Test Forum Topic'
    click_on 'New Forum Topic'

    fill_in 'Title', with: forum_topic_title
    click_on 'Create Forum topic'

    assert has_text? forum_topic_title
  end

  test 'should create new part subattribute' do
    part_topic = forum_topics(:feedback)
    visit admin_forum_topics_path
    forum_topic_title = 'Feedback subtopic'

    click_on 'New Forum Topic'
    fill_in 'Title', with: forum_topic_title
    select part_topic.title, from: 'Parent'
    click_on 'Create Forum topic'

    assert has_text? forum_topic_title
  end

  test 'should show a forum_topics page' do
    forum_topic = forum_topics(:feedback)
    visit admin_forum_topic_path(forum_topic)

    assert has_text? 'Forum Topic'
  end

  test 'should edit part attribute' do
    forum_topic = forum_topics(:feedback)
    visit edit_admin_forum_topic_path(forum_topic)

    assert has_text? 'Editing Forum Topic'
    # TODO add edit steps here
  end

  # test 'should destroy forum_topic' do
  #
  # end
end
