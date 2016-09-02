class Admin::BrandsController < Admin::DashboardController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    @brands = Brand.page(params[:page]).order("name ASC")
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
