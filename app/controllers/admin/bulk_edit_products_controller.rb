class Admin::BulkEditProductsController < Admin::ApplicationController

  def index
    products = Product.all
    @search = params[:search]
    if @search
      if @search[:ebay_category_id].present?
        categories = EbayCategory.find(@search[:ebay_category_id]).descendants
        products = products.where(ebay_category_id: categories)
      end
      products = products.where("name ilike ?", "%#{@search[:keyword]}%") if @search[:keyword].present?
      if @search[:exclude].present?
        @excluded_terms = @search[:exclude].split(",").map(&:strip)
        @excluded_terms.each do |term|
          products = products.where("name not ilike ?", "%#{term}%")
        end
      end
      if @search[:category_status].present?
        products = products.where(category_id: nil) if @search[:category_status] == "1"
        products = products.where.not(category_id: nil) if @search[:category_status] == "2"
      end
    end
    @products = products.includes(:brand, :category, :ebay_category).order("name ASC").page(params[:page]).per(100)
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

    def product_collection_params
      params.permit(product_ids: [])
    end

    def product_params
      params.require(:product).permit(:category_id)
    end
end
