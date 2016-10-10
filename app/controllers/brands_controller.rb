class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :models]
  before_action :authenticate_user!#, except: [:index, :show]

  def index
    @brands = Brand.order("name ASC").group_by{|u| u.name[0]}
  end

  def show
  end

  def models
    @models = @brand.vehicle_models.order(name: :asc)
    respond_to do |format|
      format.js
    end
  end

  private
    # FIXME should't need .friendly. in this call
    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end
end
