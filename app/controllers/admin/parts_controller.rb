class Admin::PartsController < Admin::DashboardController
  before_action :set_part, only: [:show, :edit, :update, :destroy, :update_ebay_fitments]

  def index
    parts = Part.includes(:product, {product: [:brand, :category]}, :part_attributes)
    @parts = parts.page(params[:page])
    @part = Part.new
    @attributes = PartAttribute.attribute_parents
  end

  def show
    @compatibles = @part.compatibles
  end

  def edit
    @attributes = PartAttribute.attribute_parents
  end

  def create
    @part = current_user.parts.build(part_params)

    if @part.save
      redirect_to admin_part_path(@part), notice: 'Part was successfully created.'
    else
      render :index
    end
  end

  def update
    if @part.update(part_params)
      redirect_to admin_part_path(@part), notice: 'Part was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @part.destroy
    redirect_to admin_parts_path, notice: 'Part was successfully destroyed.'
  end

  def update_ebay_fitments
    @part.update_fitments_from_ebay
    redirect_to admin_part_path(@part), notice: "Part fitments updated"
  end

  private
    def set_part
      @part = Part.friendly.find(params[:id])
    end

    def part_params
      params.require(:part).permit(:part_number, :note, :product_id, :user_id, part_traits_attributes: [:id, :part_attribute_id, :_destroy])
    end
end
