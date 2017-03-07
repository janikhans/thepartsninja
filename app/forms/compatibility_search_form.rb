class CompatibilitySearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  # TODO add validations and error callbacks
  attr_accessor :category_name, :category_id, :vehicle, :fitment_note_id, :fitment_note_name, :user,
    :vehicle_brand, :vehicle_model, :vehicle_submodel, :vehicle_year, :compatibility_search

  validates :category_name, presence: true
  validates :vehicle, presence: true

  def initialize(params = {})
    @vehicle = set_vehicle(params[:vehicle])
    @category = set_category(params)
    @category_name = params[:category_name]
    @fitment_note = set_fitment_note(params)
    @user = nil
  end

  def save
    return false unless valid?
    self.compatibility_search = create_compatibility_search
  end

  private

  def create_compatibility_search
    search_record = CompatibilitySearch.new(vehicle: @vehicle,
                              category: @category,
                              category_name: @category_name,
                              user: @user,
                              fitment_note: @fitment_note)
    search_record.process(eager_load: true)
    if search_record.compatible_vehicles.any?
      results = search_record.compatible_vehicles.first.results_count
    else
      results = 0
    end
    search_record.results_count = results
    search_record.save
    search_record
  end

    def set_category(params)
      if params[:category_id].present?
        Category.find_by(id: params[:category_id])
      elsif params[:category_name].present?
        # Currently set so we're only using the Motrycycle Parts category Category.id => 1
        Category.first.descendants.leaves.where('lower(name) = ?', params[:category_name].downcase).first
      else
        # return error
      end
    end

    def set_fitment_note(params)
      if params[:fitment_note_id].present?
        FitmentNote.find_by(id: params[:fitment_note_id])
      elsif params[:fitment_note_name].present?
        FitmentNote.where('lower(name) = ?', params[:fitment_note_name].downcase).first
      else
        # return error
      end
    end

    def set_vehicle(vehicle_params)
      return if vehicle_params.blank? # should add error
      if vehicle_params[:id].present?
        vehicle = Vehicle.find_by(id: vehicle_params[:id])
      elsif vehicle_params[:brand].present? && vehicle_params[:model].present? && vehicle_params[:year].present?
        vehicle = Vehicle.find_with_specs(vehicle_params[:brand],vehicle_params[:model],vehicle_params[:year])
      else
        # return error
      end
    end
end
