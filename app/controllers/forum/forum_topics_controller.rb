class Forum::ForumTopicsController < Forum::ApplicationController
  def index
    @topics = ForumTopic.available.includes(forum_posts: :user).arrange
  end

  def show
    @topic = ForumTopic.available.friendly.find(params[:id])
    redirect_to forum_root_path if @topic.root?
    @threads = @topic.forum_threads.includes(:user, last_forum_post: :user)
  end
end
