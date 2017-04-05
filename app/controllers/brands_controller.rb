class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :models]
  before_action :authenticate_user!, except: [:models]

  def index
    @brands = Brand.order("name ASC").group_by{|u| u.name[0]}
  end

  def show
  end

  def models
    @models = @brand.vehicle_models.joins(:vehicle_type).where('vehicle_models.vehicle_type_id = ?',1).order(name: :asc)
    render json: @models, only: [:id, :name]
  end

  private
    # FIXME should't need .friendly. in this call
    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end
end
