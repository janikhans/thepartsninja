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

    respond_to do |format|
      if @part_attribute.save
        format.html { redirect_to admin_part_attributes_path, notice: 'Part Attribute was successfully created.' }
      else
        format.html { render :index }
      end
    end
  end

  def update
    respond_to do |format|
      if @part_attribute.update(part_attribute_params)
        format.html { redirect_to admin_part_attribute_path(@part_attribute), notice: 'Part Attribute was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @part_attribute.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: 'Part Attribute was successfully destroyed.' }
    end
  end

  private
    def set_part_attribute
      @part_attribute = PartAttribute.find(params[:id])
    end

    def part_attribute_params
      params.require(:part_attribute).permit(:name, :parent_id)
    end
end
