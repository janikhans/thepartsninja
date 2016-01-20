class CompatiblesController < ApplicationController
  include Admin
  before_action :set_compatible, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_only

  # GET /compatibles
  # GET /compatibles.json
  def index
    @compatibles = Compatible.all
  end

  # GET /compatibles/1
  # GET /compatibles/1.json
  def show
  end

  # GET /compatibles/new
  def new
    @compatible = Compatible.new
    @fitments = Fitment.all
  end

  # GET /compatibles/1/edit
  def edit
  end

  # POST /compatibles
  # POST /compatibles.json
  def create
    @compatible = Compatible.new(compatible_params)

    respond_to do |format|
      if @compatible.save
        format.html { redirect_to @compatible, notice: 'Compatible was successfully created.' }
        format.json { render :show, status: :created, location: @compatible }
      else
        format.html { render :new }
        format.json { render json: @compatible.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compatibles/1
  # PATCH/PUT /compatibles/1.json
  def update
    respond_to do |format|
      if @compatible.update(compatible_params)
        format.html { redirect_to @compatible, notice: 'Compatible was successfully updated.' }
        format.json { render :show, status: :ok, location: @compatible }
      else
        format.html { render :edit }
        format.json { render json: @compatible.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compatibles/1
  # DELETE /compatibles/1.json
  def destroy
    @compatible.destroy
    respond_to do |format|
      format.html { redirect_to compatibles_url, notice: 'Compatible was successfully destroyed.' }
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
      params.require(:compatible).permit(:fitment_id, :compatible_fitment_id, :discovery_id, :user_id, :backwards)
    end
end
