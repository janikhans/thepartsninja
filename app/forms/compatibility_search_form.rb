class CompatibilitySearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include SearchableForm

  # TODO add error messages

  attr_accessor :category_name, :category, :vehicle, :fitment_note, :user, :compatibility_search, :search_type

  validates :category_name, presence: true
  validates :vehicle, presence: true

  def initialize(params = {})
    @vehicle = set_vehicle(params[:vehicle])
    @category = set_category(params[:category])
    @category_name = params[:category].try(:[], :name)
    @fitment_note = set_fitment_note(params[:fitment_note])
    @search_type = "known"
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
                              fitment_note: @fitment_note,
                              search_type: @search_type)
    search_record.process(eager_load: true)
    if search_record.successful?
      search_record.results_count = search_record.vehicles.first.results_count
    end
    search_record.save
    search_record
  end
end
