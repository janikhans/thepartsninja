class Admin::CategoriesController < Admin::DashboardController
  before_action :set_category, only: [:show, :edit, :update, :destroy]


  def index
    @categories = Category.includes(:subcategories)
    @category = Category.new
    @parent_categories = Category.all
  end

  def show
    @imported_parts_count = Part.joins(:product)
        .where('products.category_id = ? AND parts.ebay_fitments_imported = true', @category.id)
        .count
    @need_imported_parts_count = Part.joins(:product)
        .where('products.category_id = ? AND parts.ebay_fitments_imported = false', @category.id)
        .count
    @category_parts_count = @category.products.joins(:parts).count
    @products = @category.products.includes(:brand).page(params[:page]).order("name ASC")
  end

  def edit
    @parent_categories = Category.all
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_category_path(@category), notice: 'Category was successfully created.'
    else
      render :index
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_category_path(@category), notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: 'Category was successfully destroyed.'
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end
end
