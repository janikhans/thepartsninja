class Admin::UsersController < Admin::DashboardController
  before_action :set_user, only: [:show, :destroy, :edit, :update]


   def index
     @users = User.all
   end

   def show
   end

   def edit
   end

   def update

     if params[:user]['password'].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

     respond_to do |format|
       if @user.update(user_params)
         format.html { redirect_to admin_users_path(@user), notice: 'User was successfully updated.' }
         format.json { render :show, status: :ok, location: [:admin, @user] }
       else
         format.html { render :edit }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end
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

     def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, profile_attributes: [:bio, :location])
    end

 end
