class CategoriesController < DashboardController
  before_action :set_category

  def subcategories
    render json: @category.subcategories, only: [:id, :name]
  end

  def product_types
    render json: @category.product_types, only: [:id, :name]
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
