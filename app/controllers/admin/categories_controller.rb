class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @category = Category.new
    @parent_categories = Category.roots
  end

  def show
    @new_category = Category.new
    @category_parts_count = @category.products.joins(:parts).count
    @products = @category.products.includes(:brand).page(params[:page]).order("name ASC")
  end

  def edit
    @parent_categories = Category.first
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to :back, notice: 'Category was successfully created.'
      # redirect_to admin_category_path(@category), notice: 'Category was successfully created.'
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
      params.require(:category).permit(:name, :description, :parent_id)
    end
end
