class Admin::VehicleTypesController < Admin::DashboardController
  before_action :set_vehicle_type, only: [:show, :edit, :update, :destroy]

  def index
    @vehicle_types = VehicleType.page(params[:page]).order('created_at DESC').order("name ASC")
    @vehicle_type = VehicleType.new
  end

  def show
  end

  def edit
  end

  def create
    @vehicle_type = VehicleType.new(vehicle_type_params)

    if @vehicle_type.save
      redirect_to admin_vehicle_type_path(@vehicle_type), notice: 'VehicleType was successfully created.'
    else
      render :index
    end
  end

  def update
    if @vehicle_type.update(vehicle_type_params)
      redirect_to admin_vehicle_type_path(@vehicle_type), notice: 'VehicleType was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vehicle_type.destroy
    redirect_to admin_vehicle_types_path, notice: 'VehicleType was successfully destroyed.'
  end

  private
    def set_vehicle_type
      @vehicle_type = VehicleType.find(params[:id])
    end

    def vehicle_type_params
      params.require(:vehicle_type).permit(:name)
    end
end
