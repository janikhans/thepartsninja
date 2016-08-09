class Admin::FitmentsController < Admin::DashboardController
  before_action :set_fitment, only: [:show, :edit, :update, :destroy]

  def index
    @fitments = Fitment.includes(vehicle: {vehicle_submodel: {vehicle_model: :brand}}, vehicle: :vehicle_year, part: :product, part: {product: :brand, product: :category} ).page(params[:page])
    @fitment = Fitment.new
  end

  def show
  end

  def edit
  end

  def create
    @fitment = current_user.fitments.build(fitment_params)

    respond_to do |format|
      if @fitment.save
        format.html { redirect_to admin_fitment_path(@fitment), notice: 'Fitment was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @fitment] }
      else
        format.html { render :new }
        format.json { render json: @fitment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @fitment.update(fitment_params)
        format.html { redirect_to admin_fitment_path(@fitment), notice: 'Fitment was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @fitment] }
      else
        format.html { render :edit }
        format.json { render json: @fitment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fitment.destroy
    respond_to do |format|
      format.html { redirect_to admin_fitments_path, notice: 'Fitment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fitment
      @fitment = Fitment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fitment_params
      params.require(:fitment).permit(:part_id, :vehicle_id, :discovery_id, :user_id)
    end
end
