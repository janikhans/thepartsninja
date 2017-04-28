class Forum::Topics::ThreadsController < Forum::ApplicationController
  before_action :set_topic
  before_action :set_forum_thread, only: [:show, :destroy]
  before_action :redirect_unless_root_topic, only: [:new, :create]

  def new
    @thread = @topic.forum_threads.build
  end

  def show
    @post = @thread.forum_posts.build
    @post.user = current_user
    @posts = @thread.forum_posts.all
  end

  def create
    @thread = @topic.forum_threads.build(thread_params)
    @thread.user = current_user

    if @thread.save
      redirect_to forum_topic_thread_path(@topic, @thread),
        notice: 'Thread was successfully created.'
    else
      redirect_to :back,
        alert: "Thread could not be started. #{@thread.errors.full_messages.join(' ')}"
    end
  end

  def destroy
    if @thread.destroy
      redirect_to forum_topic_path(@topic), notice: 'Thread was successfully destroyed.'
    else
      redirect_to :back, alert: 'Forum Thread could not be destroyed'
    end
  end

  private

  def set_topic
    @topic = ForumTopic.friendly.find(params[:topic_id])
  end

  def set_forum_thread
    @thread = @topic.forum_threads.friendly.find(params[:id])
  end

  def redirect_unless_root_topic
    if @topic.root?
      redirect_to :back, alert: 'Threads cannot be created for this topic'
    end
  end

  def thread_params
    params.require(:forum_thread).permit(:title, :body)
  end
end
