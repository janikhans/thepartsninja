class Admin::VehiclesController < Admin::DashboardController

  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.page(params[:page])
    @vehicle_model = VehicleModel.new
    @vehicle_model.vehicle_submodels.build
  end

  def new
    @vehicle = VehicleForm.new
  end

  def show
    @oem_parts = @vehicle.oem_parts
  end

  def edit
  end

  def create
    @vehicle = VehicleForm.new(vehicle_params)
    if @vehicle.save
      redirect_to admin_vehicles_path(@vehicle), notice: 'Vehicle was successfully created.'
    else
      render :new
    end

  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to admin_vehicles_path(@vehicle), notice: 'Vehicle was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to admin_vehicles_path, notice: 'Vehicle was successfully destroyed.'
  end

  private
  
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:brand, :model, :submodel, :year, :type)
    end
end
