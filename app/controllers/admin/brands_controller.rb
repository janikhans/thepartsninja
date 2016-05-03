class Admin::BrandsController < Admin::DashboardController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    @brands = Brand.page(params[:page]).order('created_at DESC').order("name ASC")
    @brand = Brand.new
  end

  def show
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        format.html { redirect_to admin_brand_path(@brand), notice: 'Brand was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @brand] }
      else
        format.html { render :index }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @brand.update(brand_params)
        format.html { redirect_to admin_brand_path(@brand), notice: 'Brand was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @brand] }
      else
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @brand.destroy
    respond_to do |format|
      format.html { redirect_to admin_brands_path, notice: 'Brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name, :website)
    end
  end
