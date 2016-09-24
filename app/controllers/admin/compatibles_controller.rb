class Admin::CompatiblesController < Admin::DashboardController
  before_action :set_compatible, only: [:show, :edit, :update, :destroy]

  def index
    @compatibles = Compatible.includes(:part, :compatible_part, :discovery).page(params[:page]).order('compatibles.cached_votes_score DESC')
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
    if @compatible.save
      @compatible.make_backwards_compatible if @compatible.backwards == true
      redirect_to admin_compatible_path(@compatible), notice: 'Compatible was successfully created.'
    else
      render :new
    end
  end

  def update
    if @compatible.update(compatible_params)
      redirect_to admin_compatible_path(@compatible), notice: 'Compatible was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @compatible.destroy
    redirect_to admin_compatibles_url, notice: 'Compatible was successfully destroyed.'
  end

  private

    def set_compatible
      @compatible = Compatible.find(params[:id])
    end

    def compatible_params
      params.require(:compatible).permit(:part_id, :compatible_part_id, :discovery_id, :user_id, :backwards)
    end
end
