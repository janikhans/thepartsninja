class Account::ForumPostsController < Account::ApplicationController
  before_action :set_forum
  before_action :set_forum_post, only: [:update, :destroy]

  def create
    @forum_post = @forum.forum_posts.build(forum_post_params)
    @forum_post.user = current_user

    if @forum_post.save
      redirect_to account_forum_path(@forum),
        notice: 'Forum post was successfully created.'
    else
      redirect_to :back, notice: 'Could not save post'
    end
  end

  def update
    respond_to do |format|
      if @forum_post.update(forum_post_params)
        format.html { redirect_to @forum_post, notice: 'Forum post was successfully updated.' }
        format.json { render :show, status: :ok, location: @forum_post }
      else
        format.html { render :edit }
        format.json { render json: @forum_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @forum_post.destroy
    respond_to do |format|
      format.html { redirect_to forum_posts_url, notice: 'Forum post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_forum
    @forum = Forum.find(params[:forum_id])
  end

  def set_forum_post
    @forum_post = @forum.forum_posts.find(params[:id])
  end

  def forum_post_params
    params.require(:forum_post).permit(:body)
  end
end
