class Admin::VehiclesController < Admin::DashboardController

  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.page(params[:page])
    @vehicle_model = VehicleModel.new
    @vehicle_model.vehicle_submodels.build
  end

  def new
     @vehicle = VehicleModel.new
     @vehicle.vehicle_submodels.build
    #  @vehicle.vehicle_submodel.vehicles.build
  end

  def show
    @oem_parts = @vehicle.oem_parts
  end

  def edit
  end

  def create
    @vehicle = VehicleModel.new(vehicle_params)
    @vehicle.vehicle_submodels.build
    # @vehicle.vehicle_submodel.vehicles.build

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

    # def vehicle_params
    #   params.require(:vehicle).permit(:model,
    #     :vehicle_year_id,
    #     :brand_name,
    #     :brand_id,
    #     :vehicle_submodel,
    #     { vehicle_submodel_attributes: [:id,
    #       :name,
    #       { vehicle_model_attributes: [:id,
    #         :brand_id,
    #         :name]
    #       }
    #     ]}
    #   )
    # end

    # def vehicle_params
    #   params.require(:vehicle).permit(:model,
    #     :vehicle_year_id,
    #     :brand_name,
    #     :brand_id,
    #     :vehicle_submodel,
    #     vehicle_submodel_attributes: [:id,
    #       :name]
    #   )
    # end

    def vehicle_params
      params.require(:vehicle_model).permit(:brand_id,
        :name,
        { vehicle_submodels_attributes: [:id,
          :name,
          { vehicles_attributes: [:id,
            :brand_id,
            :name,
            :vehicl_year_id,
            :model]
          }
        ]}
      )
    end
end
