class FitmentsController < ApplicationController
  before_action :set_fitment, only: [:show, :edit, :update, :destroy]

  def index
    @fitments = Fitment.all
  end

  def show
  end

  def new
    @fitment = current_user.fitments.build
  end

  def edit
  end

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

  def destroy
    @fitment.destroy
    respond_to do |format|
      format.html { redirect_to fitments_url, notice: 'Fitment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_fitment
      @fitment = Fitment.find(params[:id])
    end

    def fitment_params
      params.require(:fitment).permit(:vehicle_id, :part_id, :user_id, :oem, :verified)
    end
end
