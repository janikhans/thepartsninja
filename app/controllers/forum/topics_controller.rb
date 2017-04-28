class Forum::TopicsController < Forum::ApplicationController
  def index
    @topics = ForumTopic.available.includes(:last_forum_post).arrange
  end

  def show
    @topic = ForumTopic.available.friendly.find(params[:id])
    redirect_to forum_root_path if @topic.root?
    @threads = @topic.forum_threads.all
  end
end
