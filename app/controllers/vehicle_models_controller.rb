class VehicleModelsController < ApplicationController
  def submodels
    vehicle_model = VehicleModel.find(params[:id])
    @submodels = vehicle_model.vehicle_submodels.order(name: :asc)
    respond_to :js
  end
end
