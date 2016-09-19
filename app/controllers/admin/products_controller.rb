class Admin::ProductsController < Admin::DashboardController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:brand, :category).page(params[:page]).order("name ASC")
    @product = ProductForm.new
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    @product = ProductForm.new(product_params)
    @product.user = current_user

    if @product.save
      redirect_to admin_product_path(@product.product), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(edit_product_params)
      redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: 'Product was successfully destroyed.'
  end

  private
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:product_name, :brand, :category, :subcategory)
    end

    def edit_product_params
      params.require(:product).permit(:name, :description, :category_id)
    end
end
