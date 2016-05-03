class Admin::SearchesController < Admin::DashboardController
  before_action :set_search, only: [:destroy]

   def index
     @searches = Search.all.order(created_at: :desc).limit(50)
   end

   def destroy
     @search.destroy
     respond_to do |format|
       format.html { redirect_to admin_searches_path, notice: 'Search was successfully destroyed.' }
       format.json { head :no_content }
     end
   end

   private

     def set_search
       @search = Search.find(params[:id])
     end

 end
