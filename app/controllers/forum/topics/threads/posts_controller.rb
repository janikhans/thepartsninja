class Forum::Topics::Threads::PostsController < Forum::ApplicationController
  before_action :set_topic
  before_action :set_thread
  before_action :set_post, only: [:update, :destroy]
  before_action :require_owner, only: [:update, :destroy]

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
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to forum_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_topic
    @topic = ForumTopic.friendly.find(params[:topic_id])
  end

  def set_thread
    @thread = @topic.forum_threads.friendly.find(params[:thread_id])
  end

  def set_forum_post
    @post = @thread.forum_posts.find(params[:id])
  end

  def require_owner
    unless @post.user == current_user
      redirect_to :back, alert: 'You do not have permission to edit this post'
    end
  end

  def post_params
    params.require(:forum_post).permit(:body)
  end
end
