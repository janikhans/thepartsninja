class VehicleSubmodelsController < ApplicationController
  def vehicles
    vehicle_submodel = VehicleSubmodel.find(params[:id])
    @vehicles = vehicle_submodel.vehicles.joins(:vehicle_year)
    respond_to :js
  end
end
