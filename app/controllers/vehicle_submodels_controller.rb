class VehicleSubmodelsController < ApplicationController
  def vehicles
    vehicle_submodel = VehicleSubmodel.find(params[:id])
    @vehicles = vehicle_submodel.vehicles.includes(:vehicle_year)
    render json: @vehicles.map { |vehicle| {id: vehicle.id, name: vehicle.year} }.sort_by{ |k| k[:name]}
  end
end
