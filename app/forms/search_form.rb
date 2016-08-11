class SearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Search")
  end

  attr_accessor :brand, :model, :year, :submodel, :part
  attr_reader :vehicle, :search_record, :existing_part, :oem_results, :potential_results, :compatible_results

  # TODO better validations, such as only integers, no symbols etc
  # Return vehicle after save
  # more safety checks etc
  # rename that results method to something better

  validates :brand, :model, :part,
    length: { maximum: 75},
    presence: true

  validates :submodel,
    length: { maximum: 75 }

  validates :year,
    presence: true,
    numericality: { only_integer: true },
    inclusion: { in: 1900..Date.today.year+1,
                 message: "needs to be between 1900-#{Date.today.year+1}"}

  before_validation :string_to_integer, :sanitize_fields

  def results(current_user)
    if valid?
      existing_part = Category.where('lower(name) = ?', @part.downcase).first
      brand = Brand.where('lower(name) = ?', @brand.downcase).first
      @vehicle = find_vehicle(brand) if brand
      @search_record = build_search(current_user)
      if @vehicle
        @oem_results = find_oem_parts(@vehicle, existing_part)
        if @oem_results.any?
          @potential_results = find_potential_parts(@oem_results)
          @compatible_results = find_compatible_parts(@oem_results)
          @search_record.assign_attributes(compatibles: @compatible_results.count, potentials: @potential_results.count)
        end
      end
      @search_record.save
    else
      false
    end
  end

  private

    def string_to_integer
      if @year.is_a? String
        @year = @year.to_i
      end
    end

    def sanitize_fields
      @brand = sanitize(@brand)
      @model = sanitize(@model)
      @submodel = sanitize(@submodel)
      @part = sanitize(@part)
    end

    def sanitize(field)
      unless field.blank?
        field = field.strip
      end
    end

    def find_vehicle(brand)
      year = VehicleYear.where('year = ?', @year).first
      model = brand.vehicle_models.where('lower(name) = ?', @model.downcase).first
      if model
        submodel = find_submodel(model, @submodel)
        vehicle = Vehicle.where("vehicle_submodel_id = ? AND vehicle_year_id = ?", submodel, year).first
      else
        return false
      end
    end

    def find_submodel(model, submodel)
      if submodel.present?
        submodel = model.vehicle_submodels.where('lower(name) = ?', @submodel.downcase).first
      else
        submodel = model.vehicle_submodels.where(name: nil).first
      end
    end

    def build_search(current_user)
      if @vehicle
        new_search = Search.new(vehicle: @vehicle, part: part_name, user: current_user)
      elsif
        new_search = Search.new(brand: @brand, model: @model, year: @year, part: part_name, user: current_user)
      end
      return new_search
    end

    def part_name
      if existing_part
        existing_part.name
      else
        @part
      end
    end

    def find_oem_parts(vehicle, part)
      oem_results = []
      oem_parts = vehicle.oem_parts
      oem_parts.each do |p|
        # if p.product.category.name.downcase.include? @part.downcase
        if p.product.category === part
          oem_results << p
        end
      end
      return oem_results
    end

    def find_compatible_parts(oem_parts)
      compatible_parts = []
      oem_parts.each do |p|
        compatible_parts << p.compatibles
      end
      compatible_parts.flatten!
      return compatible_parts.sort_by {|c| c.cached_votes_score }.reverse
    end

    def find_potential_parts(oem_parts)
      potential_parts = []
      oem_parts.each do |p|
        potential_parts << p.find_potentials
      end
      return potential_parts.flatten!
    end
end
