class Admin::DiscoveriesController < Admin::ApplicationController
  before_action :set_discovery, only: [:show, :edit, :update, :destroy]

  def index
    @discoveries = Discovery.includes(:user).page(params[:page]).order('created_at DESC')
  end

  def show
    @steps = @discovery.steps.all
    @user = @discovery.user
  end

  def edit
  end

  def update
    if @discovery.update(discovery_params)
      redirect_to admin_discovery_path(@discovery), notice: 'Discovery was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @discovery.destroy
    redirect_to admin_discoveries_path, notice: 'Discovery was successfully destroyed.'
  end

  private
    def set_discovery
      @discovery = Discovery.find(params[:id])
    end

    def discovery_params
      params.require(:discovery).permit(:user_id, :comment, :modifications, :oem_part_brand, :oem_part_name, :oem_vehicle_brand, :oem_vehicle_year, :oem_vehicle_model, :compatible_vehicle_brand, :compatible_vehicle_year, :compatible_vehicle_model, :compatible_part_name, :compatible_part_brand, :backwards, compatibles_attributes: [:id, :fitment_id, :compatible_fitment_id, :backwards, :_destroy], steps_attributes: [:id, :content, :_destroy] )
    end
end
