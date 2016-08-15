class Admin::PartAttributesController < Admin::DashboardController
  before_action :set_part_attribute, only: [:show, :edit, :update, :destroy]


  def index
    @part_attributes = PartAttribute.includes(:attribute_variations)
    @part_attribute = PartAttribute.new
    @attribute_parents = PartAttribute.attribute_parents
  end

  def show
  end

  def edit
    @attribute_parents = PartAttribute.attribute_parents
  end

  def create
    @part_attribute = PartAttribute.new(part_attribute_params)

    if @part_attribute.save
      redirect_to admin_part_attributes_path, notice: 'Part Attribute was successfully created.'
    else
      render :index
    end
  end

  def update
    if @part_attribute.update(part_attribute_params)
      redirect_to admin_part_attribute_path(@part_attribute), notice: 'Part Attribute was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @part_attribute.destroy
    redirect_to admin_categories_url, notice: 'Part Attribute was successfully destroyed.'
  end

  private
    def set_part_attribute
      @part_attribute = PartAttribute.find(params[:id])
    end

    def part_attribute_params
      params.require(:part_attribute).permit(:name, :parent_id)
    end
end
