class Admin::VehiclesController < Admin::DashboardController

  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.page(params[:page])
    @vehicle_model = VehicleModel.new
    @vehicle_model.vehicle_submodels.build
  end

  def new
     @vehicle = Vehicle.new
     @vehicle.build_vehicle_submodel
     @vehicle.vehicle_submodel.build_vehicle_model
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
        format.html { render :new }
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
      params.require(:vehicle).permit(:vehicle_year_id, :vehicle_submodel_id, vehicle_submodel_attributes: [:id, :name, :vehicle_model_id, :_destroy, vehicle_model_attributes: [:id, :name, :brand_id, :_destroy, brand_attributes: [:id, :name, :_destroy]]])
    end

end
