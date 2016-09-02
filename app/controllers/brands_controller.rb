class BrandsController < ApplicationController
  before_action :set_brand, only: [:show]
  before_action :authenticate_user!#, except: [:index, :show]

  def autocomplete
    @brands = Brand.order(:name)
    @brands = @brands.where("name like ?", "%#{params[:term]}%") if params[:term]

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render json: @brands.map(&:name)} #{ render json: @brands.map{|brand| {label: "#{brand.name}", value: brand.id} }}
    end
  end

  def index
    @brands = Brand.order("name ASC").group_by{|u| u.name[0]}
  end

  def show
  end

  private
    # FIXME should't need .friendly. in this call
    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end
end
