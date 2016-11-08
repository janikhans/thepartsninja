class Admin::CompatibilitiesController < Admin::ApplicationController
  before_action :set_compatibility, only: [:show, :edit, :update, :destroy]

  def index
    @compatibilities = Compatibility.includes(:part, :compatible_part, :discovery).page(params[:page]).order('compatibilities.cached_votes_score DESC')
  end

  def show
  end

  def new
    @compatibility = Compatibility.new
    @fitments = Fitment.all
  end

  def edit
  end

  def create
    @compatibility = Compatibility.new(compatibility_params)
    if @compatibility.save
      @compatibility.make_backwards_compatible! if @compatibility.backwards == true
      redirect_to admin_compatibility_path(@compatibility), notice: 'Compatibility was successfully created.'
    else
      render :new
    end
  end

  def update
    if @compatibility.update(compatibility_params)
      redirect_to admin_compatibility_path(@compatibility), notice: 'Compatibility was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @compatibility.destroy
    redirect_to admin_compatibilities_url, notice: 'Compatibility was successfully destroyed.'
  end

  private

    def set_compatibility
      @compatibility = Compatibility.find(params[:id])
    end

    def compatibility_params
      params.require(:compatibility).permit(:part_id, :compatible_part_id, :discovery_id, :user_id, :backwards)
    end
end
