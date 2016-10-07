class DiscoveriesController < ApplicationController
  before_action :set_discovery, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!#, except: [:index, :show]

  def show
    @steps = @discovery.steps.all
    @user = @discovery.user
  end

  def new
    @discovery = current_user.discoveries.build
    @compatibility = @discovery.compatibilities.build
    @fitments = Fitment.all
  end

  def edit
  end

  def create

    #the params for the OEM (og foo!) vehicle
    og_brand_name = params[:discovery][:oem_vehicle_brand]
    og_model = params[:discovery][:oem_vehicle_model]
    og_year = params[:discovery][:oem_vehicle_year]

    #This is done in case a part does not comes from a vehicle - ie Radio Shack electric motor
    unless (og_brand_name.blank? || og_model.blank? || og_year.blank?)
      og_brand_name.strip
      og_model.strip
      og_brand = Brand.where('lower(name) = ?', og_brand_name.downcase).first_or_create(name: og_brand_name)
      og_year = VehicleYear.where('year = ?', og_year.to_i).first
      og_vehicle = Vehicle.where('brand_id = ? AND vehicle_year_id = ? AND lower(model) = ?', og_brand.id, og_year.id, og_model.downcase).first_or_create(brand: og_brand, vehicle_year: og_year, model: og_model)
    end

    #Here we are finding the base part. Take params - then find or create the brand - then find or create the product belonging to this brand
    og_part_brand_name = params[:discovery][:oem_part_brand].strip
    og_part_brand = Brand.where('lower(name) = ?', og_part_brand_name.downcase).first_or_create(name: og_part_brand_name)
    og_part_name = params[:discovery][:oem_part_name].strip
    og_product = Product.where(brand: og_part_brand).where('lower(name) = ?', og_part_name.downcase).first_or_create(brand: og_part_brand, name: og_part_name, category: Category.first)

    #Here we are finding the vehicle that the above part is compatible with. Again, we are taking the params, sanitizing and then finding or creating the brand, then the vehicle find or create
    compat_brand_name = params[:discovery][:compatible_vehicle_brand].strip
    compat_brand = Brand.where('lower(name) = ?', compat_brand_name.downcase).first_or_create(name: compat_brand_name)
    compat_model = params[:discovery][:compatible_vehicle_model].strip
    compat_year = params[:discovery][:compatible_vehicle_year]
    compat_year = VehicleYear.where('year = ?', compat_year.to_i).first
    compat_vehicle = Vehicle.where('brand_id = ? AND vehicle_year_id = ? AND lower(model) = ?', compat_brand.id, compat_year.id, compat_model.downcase).first_or_create(brand: compat_brand, vehicle_year: compat_year, model: compat_model)

    #Now we are creating the prouduct and part. Taking/saniziting params - finding or creating brand - taking product name param and sanitizing - creating or finding the product with the above params
    compat_part_brand_name = params[:discovery][:compatible_part_brand].strip
    compat_part_brand = Brand.where('lower(name) = ?', compat_part_brand_name.downcase).first_or_create(name: compat_part_brand_name)
    compat_part_name = params[:discovery][:compatible_part_name].strip
    compat_product = Product.where(brand: compat_part_brand).where('lower(name) = ?', compat_part_name.downcase).first_or_create(brand: compat_part_brand, name: compat_part_name, category: Category.first)

    #first step is finding the fitment between the original vehicle and original part - then making sure it is selected
    if og_vehicle
      og_part = Part.create! product: og_product, user: current_user
      og_fitment = Fitment.create! vehicle: og_vehicle, part: og_part, user: current_user
    else
      og_part = Part.create! product: og_product, user: current_user
    end
    # og_part = og_vehicle.fitments.where(part: og_fitment_part).first

    #doing the same for the compatible part
    compat_part = Part.create! product: compat_product, user: current_user
    compat_fitment = Fitment.create! vehicle: compat_vehicle, part: compat_part, user: current_user
    # compat_fitment = compat_vehicle.fitments.where(part: compat_fitment_part).first

    #building the compatible that belongs to the discovery
    @discovery = current_user.discoveries.build(discovery_params)
    @compatibility = @discovery.compatibilities.build
    @compatibility.part = og_part
    @compatibility.compatible_part = compat_part
    @compatibility.backwards = params[:discovery][:backwards]
    @compatibility.modifications = params[:discovery][:modifications]

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
      params.require(:discovery).permit(:user_id,
                                        :comment,
                                        :oem_part_brand,
                                        :oem_part_name,
                                        :oem_vehicle_brand,
                                        :oem_vehicle_year,
                                        :oem_vehicle_model,
                                        :compatible_vehicle_brand,
                                        :compatible_vehicle_year,
                                        :compatible_vehicle_model,
                                        :compatible_part_name,
                                        :compatible_part_brand,
                                        :backwards,
                                        compatibilities_attributes: [:id, :fitment_id, :compatible_fitment_id, :backwards, :_destroy],
                                        steps_attributes: [:id, :content, :_destroy]
    )
    end
end
