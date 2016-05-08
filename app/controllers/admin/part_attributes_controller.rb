class Admin::PartAttributesController < Admin::DashboardController
  before_action :set_part_attribute, only: [:show, :edit, :update, :destroy]


  def index
    @part_attributes = PartAttribute.includes(:subcategories)
    @part_attribute = PartAttribute.new
    @parent_categories = PartAttribute.all
  end

  def show
  end

  def edit
    @parent_categories = PartAttribute.all
  end

  def create
    @part_attribute = PartAttribute.new(part_attribute_params)

    respond_to do |format|
      if @part_attribute.save
        format.html { redirect_to admin_part_attribute_path(@part_attribute), notice: 'PartAttribute was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @part_attribute] }
      else
        format.html { render :index }
        format.json { render json: @part_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @part_attribute.update(part_attribute_params)
        format.html { redirect_to admin_part_attribute_path(@part_attribute), notice: 'PartAttribute was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @part_attribute] }
      else
        format.html { render :edit }
        format.json { render json: @part_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @part_attribute.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: 'PartAttribute was successfully destroyed.' }
      format.json { head :no_content }
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
