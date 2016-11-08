class Admin::VehiclesController < Admin::ApplicationController

  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.includes(:vehicle_year, vehicle_submodel: {vehicle_model: [:brand, :vehicle_type]})
        .page(params[:page])
    @vehicle_model = VehicleModel.new
    @vehicle_model.vehicle_submodels.build
  end

  def new
    @vehicle = VehicleForm.new
  end

  def show
    oem_parts = @vehicle.oem_parts.includes(:part_attributes, product: [:brand, :category])
    @oem_parts_count = oem_parts.count
    @oem_parts = oem_parts.page(params[:page])
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
      @vehicle = Vehicle.friendly.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:brand, :model, :submodel, :year, :type)
    end
end
