class Admin::VehiclesController < Admin::DashboardController

  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.all
    @vehicle = Vehicle.new
  end

  def show
    @oem_parts = @vehicle.oem_parts
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to admin_vehicles_path(@vehicle), notice: 'Vehicle was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @vehicle] }
      else
        format.html { render :index }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to admin_vehicles_path(@vehicle), notice: 'Vehicle was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @vehicle] }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to admin_vehicles_path, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:model, :year, :brand_name, :brand_id)
    end
end
