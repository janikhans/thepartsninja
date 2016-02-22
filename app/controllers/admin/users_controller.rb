class Admin::UsersController < Admin::DashboardController
  before_action :set_user, only: [:show, :destroy]


   def index
     @users = User.all
   end

   def show
   end

   def destroy
     @user.destroy
     respond_to do |format|
       format.html { redirect_to admin_users_path, notice: 'User was successfully destroyed.' }
       format.json { head :no_content }
     end
   end

   private

     def set_user
       @user = User.find(params[:id])
     end

 end
