class Admin::BrandsController < Admin::ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    @query = params[:q]
    if @query.present?
      brands = Brand.where("name ilike ?", "%#{@query}%")
    else
      brands = Brand.all
    end
    @brands = brands.order("name ASC").page(params[:page])
    @brands_count = brands.count
    @brand = Brand.new
  end

  def show
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to admin_brand_path(@brand), notice: 'Brand was successfully created.'
    else
      render :index
    end
  end

  def update
    if @brand.update(brand_params)
      redirect_to admin_brand_path(@brand), notice: 'Brand was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @brand.destroy
    redirect_to admin_brands_path, notice: 'Brand was successfully destroyed.'
  end

  private
    # FIXME shouldn't need this .friendly. method in this call
    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name, :website)
    end
end
