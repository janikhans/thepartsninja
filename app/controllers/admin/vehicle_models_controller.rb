class Admin::VehicleModelsController < Admin::DashboardController

  before_action :set_vehicle_model, only: [:edit, :update, :destroy]

  def new
     @vehicle_model = VehicleModel.new
  end

  def edit
  end

  def create
    @vehicle_model = VehicleModel.new(vehicle_params)

    if @vehicle_model.save
      redirect_to admin_vehicles_path, notice: 'Vehicle was successfully created.'
    else
     render :new
    end
  end

  def update
    if @vehicle_model.update(vehicle_params)
      redirect_to admin_vehicles_path(@vehicle_model), notice: 'Vehicle was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_vehicle_model
      @vehicle_model = VehicleModel.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle_model).permit(:brand_id,
        :name,
        { vehicle_submodels_attributes: [:id,
          :name,
          vehicles_attributes: [:id,
            :brand_id,
            :vehicle_year_id,
            :vehicle_submodel_id,
            :_destroy]
        ]}
      )
    end
end
