class Admin::DashboardsController < Admin::ApplicationController
  def show
    last_24_hours = (Time.current - 24.hours)..Time.current
    @recent_leads = Lead.where('created_at::DATE = ?', Date.current).count
    @recent_searches = SearchRecord.where('created_at::DATE = ?', Date.current).count
    @recent_users = User.where('created_at::DATE = ?', Date.current).count
    @recent_forum_posts = ForumPost.where(created_at: last_24_hours)
                                   .includes(:user, forum_thread: :forum_topic)
                                   .page(params[:page])
                                   .per(5)
    @recent_forum_threads = ForumThread.where(created_at: last_24_hours)
                                       .includes(:user, :forum_topic)
                                       .page(params[:page])
                                       .per(5)
  end
end
