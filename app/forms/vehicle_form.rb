class VehicleForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  
  def self.model_name
    ActiveModel::Name.new(self, nil, "Vehicle")
  end

  attr_accessor :brand, :vehicle_model, :vehicle_submodel, :vehicle_year

  validates :brand, :vehicle_model, :vehicle_year, presence: true

  before_validation :sanitize_name

  def submit(params)
    if valid?
      brand = Brand.where(name: params[:brand]).first_or_create!
      model = brand.vehicle_models.where(name: params[:vehicle_model]).first_or_create!
      binding.pry
      if params[:vehicle_submodel].present?
        submodel = model.vehicle_submodels.where(name: params[:vehicle_submodel]).first_or_create!
      else
        submodel = model.vehicle_submodels.where(name: nil).first_or_create!
      end
      vehicle = Vehicle.create(vehicle_year_id: params[:vehicle_year], vehicle_submodel: submodel)
      if vehicle.save
        true
      else
        false
      end
    else
      false
    end
  end


  private

    def sanitize_name
      unless self.brand.blank?
        self.brand = brand.strip
        self.brand = brand[0].upcase + brand[1..-1]
      end
    end

end
