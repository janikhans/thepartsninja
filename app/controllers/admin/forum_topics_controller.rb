class Admin::ForumTopicsController < Admin::ApplicationController
  before_action :set_forum_topic, only: [:show, :edit, :update, :destroy]

  def index
    @forum_topics = ForumTopic.all
  end

  def show
  end

  def new
    @forum_topic = ForumTopic.new
  end

  def edit
  end

  def create
    @forum_topic = ForumTopic.new(forum_topic_params)

    if @forum_topic.save
      redirect_to admin_forum_topic_path(@forum_topic), notice: 'Forum topic was successfully created.'
    else
      render :new
    end
  end

  def update
    if @forum_topic.update(forum_topic_params)
      redirect_to admin_forum_topics_path(@forum_topic),
        notice: 'Forum topic was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @forum_topic.destroy
      redirect_to admin_forum_topics_path, notice: 'Forum topic was successfully destroyed.'
    else
      redirect_to :back, alert: 'Could not destroy topic'
    end
  end

  private

  def set_forum_topic
    @forum_topic = ForumTopic.friendly.find(params[:id])
  end

  def forum_topic_params
    params.require(:forum_topic).permit(:title, :description, :private, :icon, :parent_id, :slug)
  end
end
