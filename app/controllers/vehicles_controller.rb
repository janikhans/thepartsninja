class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show]
  before_action :authenticate_user!#, except: [:index, :show]

  def index
    @vehicles = Vehicle.all
  end

  def show
    @oem_parts = @vehicle.oem_parts
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end
end
