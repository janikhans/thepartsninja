class Account::ForumThreadsController < Account::ApplicationController
  before_action :set_forum_thread, only: [:show, :destroy]

  def index
    @forum_thread = current_user.forum_threads.build
    @forum_threads = current_user.forum_threads.all
  end

  def show
    @forum_thread_post = @forum_thread.forum_thread_posts.build
    @forum_thread_post.user = current_user
    @forum_thread_posts = @forum_thread.forum_thread_posts
  end

  def create
    @forum_thread = current_user.forum_threads.build(forum_thread_params)

    if @forum_thread.save
      redirect_to account_forum_threads_path(@forum_thread),
        notice: 'Forum Thread was successfully created.'
    else
      redirect_to :back,
        alert: "Forum Thread could not be started. #{@forum_thread.errors.full_messages.join(' ')}"
    end
  end

  def destroy
    if @forum_thread.destroy
      redirect_to forum_threads_url, notice: 'Forum Thread was successfully destroyed.'
    else
      redirect_to :back, alert: 'Forum Thread could not be destroyed'
    end
  end

  private

  def set_forum_thread
    @forum_thread = current_user.forum_threads.find(params[:id])
  end

  def forum_thread_params
    params.require(:forum_thread).permit(message_attributes: [:body])
  end
end
