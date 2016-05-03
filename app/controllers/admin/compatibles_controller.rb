class Admin::CompatiblesController < Admin::DashboardController
  before_action :set_compatible, only: [:show, :edit, :update, :destroy]


  def index
    @compatibles = Compatible.page(params[:page]).order('compatibles.cached_votes_score DESC')
  end

  def show
  end

  def new
    @compatible = Compatible.new
    @fitments = Fitment.all
  end

  def edit
  end

  def create
    @compatible = Compatible.new(compatible_params)

    respond_to do |format|
      if @compatible.save
        format.html { redirect_to admin_compatible_path(@compatible), notice: 'Compatible was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @compatible] }
      else
        format.html { render :new }
        format.json { render json: @compatible.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @compatible.update(compatible_params)
        format.html { redirect_to admin_compatible_path(@compatible), notice: 'Compatible was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @compatible] }
      else
        format.html { render :edit }
        format.json { render json: @compatible.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @compatible.destroy
    respond_to do |format|
      format.html { redirect_to admin_compatibles_url, notice: 'Compatible was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compatible
      @compatible = Compatible.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compatible_params
      params.require(:compatible).permit(:part_id, :compatible_part_id, :discovery_id, :user_id, :backwards)
    end
end
