class Admin::BulkEditProductsController < Admin::ApplicationController

  def index
    products = Product.includes(:brand, :category, :ebay_category)
    @search = search
    if @search
      if @search[:ebay_category_id].present?
        categories = EbayCategory.find(@search[:ebay_category_id]).descendants
        products = products.where(ebay_category_id: categories)
      end
      products = products.where("name ilike ?", "%#{@search[:keyword]}%").includes(:brand, :ebay_category, :category) if @search[:keyword].present?
      products = products.where(category_id: nil) if @search[:nil_category] == "1"
    end
    @products = products.order("name ASC").page(params[:page])
    @products_count = products.count
  end

  def new
    @products = Product.where(id: product_collection_params[:product_ids]).includes(:brand, :ebay_category)
    @product = Product.new
  end

  def create
    @products = Product.where(id: product_collection_params[:product_ids])

    if @products.update_all(category_id: product_params[:category_id])
      redirect_to :back, notice: "#{@products.count} Products successfully updated"
      # redirect_to admin_product_path(@product.product), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  private

    def search
      @search = params[:search]
    end

    def product_collection_params
      params.permit(product_ids: [])
    end

    def product_params
      params.require(:product).permit(:category_id)
    end
end
