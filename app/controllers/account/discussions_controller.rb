class Account::DiscussionsController < Account::ApplicationController
  before_action :set_discussion, only: [:show, :destroy]

  def index
    @discussion = current_user.discussions.build
    @discussions = current_user.discussions.all
  end

  def show
  end

  def create
    @discussion = current_user.discussions.build(discussion_params)

    if @discussion.save
      redirect_to account_discussions_path(@discussion),
        notice: 'Discussion was successfully created.'
    else
      redirect_to :back,
        alert: "Discussion could not be started. #{@discussion.errors.full_messages.join(' ')}"
    end
  end

  def destroy
    if @discussion.destroy
      redirect_to discussions_url, notice: 'Discussion was successfully destroyed.'
    else
      redirect_to :back, alert: 'Discussion could not be destroyed'
    end
  end

  private

  def set_discussion
    @discussion = current_user.discussions.find(params[:id])
  end

  def discussion_params
    params.require(:discussion).permit(message_attributes: [:body, :user_id])
  end
end
