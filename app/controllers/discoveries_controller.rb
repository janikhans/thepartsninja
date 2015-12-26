class DiscoveriesController < ApplicationController
  before_action :set_discovery, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /discoveries
  # GET /discoveries.json
  def index
    @discoveries = Discovery.all
  end

  # GET /discoveries/1
  # GET /discoveries/1.json
  def show
    @steps = @discovery.steps.all
    @user = @discovery.user
  end

  # GET /discoveries/new
  def new
    @discovery = current_user.discoveries.build
    @compatible = @discovery.compatibles.build
    @fitments = Fitment.all
  end

  # GET /discoveries/1/edit
  def edit
  end

  # POST /discoveries
  # POST /discoveries.json
  def create
    @discovery = current_user.discoveries.build(discovery_params)

    respond_to do |format|
      if @discovery.save
        format.html { redirect_to @discovery, notice: 'Discovery was successfully created.' }
        format.json { render :show, status: :created, location: @discovery }
      else
        format.html { render :new }
        format.json { render json: @discovery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discoveries/1
  # PATCH/PUT /discoveries/1.json
  def update
    respond_to do |format|
      if @discovery.update(discovery_params)
        format.html { redirect_to @discovery, notice: 'Discovery was successfully updated.' }
        format.json { render :show, status: :ok, location: @discovery }
      else
        format.html { render :edit }
        format.json { render json: @discovery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discoveries/1
  # DELETE /discoveries/1.json
  def destroy
    @discovery.destroy
    respond_to do |format|
      format.html { redirect_to discoveries_url, notice: 'Discovery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discovery
      @discovery = Discovery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discovery_params
      params.require(:discovery).permit(:user_id, :comment, :modifications, compatibles_attributes: [:id, :fitment_id, :compatible_fitment_id, :backwards, :_destroy], steps_attributes: [:id, :content, :_destroy])
    end
end
