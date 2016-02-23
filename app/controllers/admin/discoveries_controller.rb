class Admin::DiscoveriesController < Admin::DashboardController
  before_action :set_discovery, only: [:show, :edit, :update, :destroy]

  def index
    @discoveries = Discovery.all
  end

  def show
    @steps = @discovery.steps.all
    @user = @discovery.user
  end

  def edit
  end

  def update
    respond_to do |format|
      if @discovery.update(discovery_params)
        format.html { redirect_to admin_discovery_path(@discovery), notice: 'Discovery was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @discovery] }
      else
        format.html { render :edit }
        format.json { render json: @discovery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discovery.destroy
    respond_to do |format|
      format.html { redirect_to admin_discoveries_path, notice: 'Discovery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discovery
      @discovery = Discovery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discovery_params
      params.require(:discovery).permit(:user_id, :comment, :modifications, :oem_part_brand, :oem_part_name, :oem_vehicle_brand, :oem_vehicle_year, :oem_vehicle_model, :compatible_vehicle_brand, :compatible_vehicle_year, :compatible_vehicle_model, :compatible_part_name, :compatible_part_brand, :backwards, compatibles_attributes: [:id, :fitment_id, :compatible_fitment_id, :backwards, :_destroy], steps_attributes: [:id, :content, :_destroy] )
    end
end
