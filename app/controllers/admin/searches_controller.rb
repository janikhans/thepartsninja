class Admin::SearchesController < Admin::DashboardController
   def index
     @searches = Search.all.order(created_at: :desc).limit(50)
   end
 end
