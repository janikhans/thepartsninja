class PartsController < ApplicationController
  include Admin
  before_action :set_part, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :admin_only, except: [:show]

  def index
    @parts = Part.all
  end

  def show
    @compatibles = @part.compats
  end

  def new
    @part = current_user.parts.build
  end

  def edit
  end

  def create
    @part = current_user.parts.build(part_params)

    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_part
      @part = Part.find(params[:id])
    end

    def part_params
      params.require(:part).permit(:part_number, :note, :product_id, :user_id)
    end
end
