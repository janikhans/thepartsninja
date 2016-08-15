class Admin::SearchesController < Admin::DashboardController
  before_action :set_search, only: [:destroy]

   def index
     @searches = Search.includes(:vehicle, :user).page(params[:page]).order('created_at DESC')
   end

   def destroy
     @search.destroy
      redirect_to admin_searches_path, notice: 'Search was successfully destroyed.'
   end

   private

     def set_search
       @search = Search.find(params[:id])
     end
 end
