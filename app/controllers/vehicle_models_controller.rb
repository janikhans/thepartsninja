class VehicleModelsController < ApplicationController
  def submodels
    vehicle_model = VehicleModel.find(params[:id])
    @submodels = vehicle_model.vehicle_submodels.order(name: :asc)
    render json: @submodels.map { |submodel| {id: submodel.id, name: submodel.adjusted_name } }
  end
end
