class Forum::ForumTopics::ForumThreads::ForumPostsController < Forum::ApplicationController
  before_action :set_topic
  before_action :set_thread
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @post = @thread.forum_posts.build(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html {
          redirect_to forum_topic_thread_path(@topic, @thread),
            notice: 'Post was successfully created.'
        }
        format.js
      else
        format.html { redirect_to :back, alert: 'Could not save post' }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to forum_topic_thread_path(@topic, @thread),
          notice: 'Post was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.js { }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to forum_topic_thread_path(@topic, @thread),
          notice: 'Post was successfully deleted.' }
      format.js { }
    end
  end

  private

  def set_topic
    @topic = ForumTopic.friendly.find(params[:topic_id])
  end

  def set_thread
    @thread = @topic.forum_threads.friendly.find(params[:thread_id])
  end

  def set_post
    @post = @thread.forum_posts.find(params[:id])
  end

  def require_owner
    unless @post.user == current_user
      respond_to do |format|
        format.html { redirect_to :back, alert: 'You do not have permission to edit this post' }
        format.js { head :no_content }
      end
    end
  end

  def post_params
    params.require(:forum_post).permit(:body)
  end
end
