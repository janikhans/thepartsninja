class Admin::EbayCategoriesController < Admin::ApplicationController
  before_action :set_ebay_category, only: [:show, :edit, :update, :destroy]


  def index
    @ebay_categories = EbayCategory.all #includes(subcategories: {subcategories: :subcategories})
    @ebay_category = EbayCategory.new
    @parent_ebay_categories = EbayCategory.all
  end

  def show
    @imported_parts_count = Part.joins(:product)
        .where('products.ebay_category_id = ? AND parts.ebay_fitments_imported = true', @ebay_category.id)
        .count
    @need_imported_parts_count = Part.joins(:product)
        .where('products.ebay_category_id = ? AND parts.ebay_fitments_imported = false', @ebay_category.id)
        .count
    @ebay_category_parts_count = @ebay_category.products.joins(:parts).count
    @products = @ebay_category.products.includes(:brand).page(params[:page]).order("name ASC")
  end

  def edit
    @parent_ebay_categories = EbayCategory.all
  end

  def create
    @ebay_category = EbayCategory.new(ebay_category_params)

    if @ebay_category.save
      redirect_to admin_ebay_category_path(@ebay_category), notice: 'Ebay Category was successfully created.'
    else
      render :index
    end
  end

  def update
    if @ebay_category.update(ebay_category_params)
      redirect_to admin_ebay_category_path(@ebay_category), notice: 'Ebay Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ebay_category.destroy
    redirect_to admin_ebay_categories_url, notice: 'Ebay Category was successfully destroyed.'
  end

  private
    def set_ebay_category
      @ebay_category = EbayCategory.find(params[:id])
    end

    def ebay_category_params
      params.require(:ebay_category).permit(:name, :parent_id)
    end
end
