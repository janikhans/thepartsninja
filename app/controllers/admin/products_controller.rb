class Admin::ProductsController < Admin::DashboardController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :update_ebay_fitments]

  def index
    @query = params[:q]
    if @query.present?
      products = Product.where("name ilike ?", "%#{@query}%").includes(:brand, :category)
    else
      products = Product.includes(:brand, :category)
    end
    @products = products.order("name ASC").page(params[:page])
    @products_count = products.count
    @product = ProductForm.new
  end

  def new
  end

  def show
    @parts = @product.parts.page(params[:page]).order("part_number ASC")
  end

  def edit
    @product_types = @product.category.product_types
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

  def update_ebay_fitments
    parts = @product.parts

    parts.each do |p|
      p.update_fitments_from_ebay
    end

    redirect_to admin_product_path(@product), notice: 'Fitments were updated.'
  end
  private
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:product_name, :brand, :category, :subcategory, :product_type_id)
    end

    def edit_product_params
      params.require(:product).permit(:name, :description, :category_id, :product_type_id)
    end
end
