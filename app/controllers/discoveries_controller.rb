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

    #find OEM Vehicle
    og_brand_name = params[:og_vehicle][:brand]
    og_model = params[:og_vehicle][:model]
    og_year = params[:og_vehicle][:year]

    if (og_brand_name.blank? || og_model.blank? || og_year.blank?)
      og_brand = Brand.where(name: "N/A").first
      og_vehicle = Vehicle.where(brand: og_brand, year: 1989, model: "N/A").first_or_create(brand: og_brand, year: 1989, model: "N/A")
    else
      og_brand_name.strip
      og_model.strip
      og_brand = Brand.where('lower(name) = ?', og_brand_name.downcase).first_or_create(name: og_brand_name)
      og_vehicle = Vehicle.where(brand: og_brand).where(year: og_year).where('lower(model) = ?', og_model.downcase).first_or_create(brand: og_brand, year: og_year, model: og_model)
    end
    

    og_part_brand_name = params[:og_part][:brand].strip
    og_part_brand = Brand.where('lower(name) = ?', og_part_brand_name.downcase).first_or_create(name: og_part_brand_name)
    og_part_name = params[:og_part][:name].strip
    og_product = Product.where(brand: og_part_brand).where('lower(name) = ?', og_part_name.downcase).first_or_create(brand: og_part_brand, name: og_part_name)

    compat_brand_name = params[:compat_vehicle][:brand].strip
    compat_brand = Brand.where('lower(name) = ?', compat_brand_name.downcase).first_or_create(name: compat_brand_name)
    compat_model = params[:compat_vehicle][:model].strip
    compat_year = params[:compat_vehicle][:year]
    compat_vehicle = Vehicle.where(brand: compat_brand).where(year: compat_year).where('lower(model) = ?', compat_model.downcase).first_or_create(brand: compat_brand, year: compat_year, model: compat_model)
   
    compat_part_brand_name = params[:compat_part][:brand].strip
    compat_part_brand = Brand.where('lower(name) = ?', compat_part_brand_name.downcase).first_or_create(name: compat_part_brand_name)
    compat_part_name = params[:compat_part][:name].strip
    compat_product = Product.where(brand: compat_part_brand).where('lower(name) = ?', compat_part_name.downcase).first_or_create(brand: compat_part_brand, name: compat_part_name) 

    og_fitment_part = og_vehicle.oem_parts.where(product: og_product).first_or_create(product: og_product)
    og_fitment = og_vehicle.fitments.where(part: og_fitment_part).first

    
    compat_fitment_part = compat_vehicle.oem_parts.where(product: compat_product).first_or_create(product: compat_product)
    compat_fitment = compat_vehicle.fitments.where(part: compat_fitment_part).first

    @discovery = current_user.discoveries.build(discovery_params)
    @compatible = @discovery.compatibles.build
    @compatible.fitment = og_fitment
    @compatible.compatible_fitment = compat_fitment
    @compatible.backwards = params[:backwards]

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
