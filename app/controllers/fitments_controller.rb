class FitmentsController < ApplicationController
  include Admin
  before_action :set_fitment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only

  # GET /fitments
  # GET /fitments.json
  def index
    @fitments = Fitment.all
  end

  # GET /fitments/1
  # GET /fitments/1.json
  def show
  end

  # GET /fitments/new
  def new
    @fitment = current_user.fitments.build
  end

  # GET /fitments/1/edit
  def edit
  end

  # POST /fitments
  # POST /fitments.json
  def create
    @fitment = current_user.fitments.build(fitment_params)

    respond_to do |format|
      if @fitment.save
        format.html { redirect_to @fitment, notice: 'Fitment was successfully created.' }
        format.json { render :show, status: :created, location: @fitment }
      else
        format.html { render :new }
        format.json { render json: @fitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fitments/1
  # PATCH/PUT /fitments/1.json
  def update
    respond_to do |format|
      if @fitment.update(fitment_params)
        format.html { redirect_to @fitment, notice: 'Fitment was successfully updated.' }
        format.json { render :show, status: :ok, location: @fitment }
      else
        format.html { render :edit }
        format.json { render json: @fitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fitments/1
  # DELETE /fitments/1.json
  def destroy
    @fitment.destroy
    respond_to do |format|
      format.html { redirect_to fitments_url, notice: 'Fitment was successfully destroyed.' }
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
