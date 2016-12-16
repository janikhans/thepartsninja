class Admin::NinjaCategoriesController < Admin::ApplicationController
  before_action :set_ninja_category, only: [:show, :edit, :update, :destroy]

  def index
    @ninja_categories = NinjaCategory.includes(subcategories: {subcategories: :subcategories})
    @ninja_category = NinjaCategory.new
    @parent_ninja_categories = NinjaCategory.all
  end

  def show
    @ninja_category_parts_count = @ninja_category.products.joins(:parts).count
    @products = @ninja_category.products.includes(:brand, :product_type).page(params[:page]).order("name ASC")
  end

  def edit
    @parent_ninja_categories = NinjaCategory.all
  end

  def create
    @ninja_category = NinjaCategory.new(ninja_category_params)

    if @ninja_category.save
      redirect_to :back, notice: "Category successfully created"
      # redirect_to admin_category_path(@ninja_category), notice: 'Category was successfully created.'
    else
      render :index
    end
  end

  def update
    if @ninja_category.update(ninja_category_params)
      redirect_to admin_ninja_category_path(@ninja_category), notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ninja_category.destroy
    redirect_to admin_ninja_categories_url, notice: 'Category was successfully destroyed.'
  end

  private
    def set_ninja_category
      @ninja_category = NinjaCategory.find(params[:id])
    end

    def ninja_category_params
      params.require(:ninja_category).permit(:name, :parent_id, subcategories_attributes: [:id, :name, :_destroy], product_types_attributes: [:id, :name, :description, :_destroy])
    end
end
