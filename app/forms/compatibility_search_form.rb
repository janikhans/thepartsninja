# Form object for taking form inputs/params and building a CompatibilitySearch
class CompatibilitySearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include SearchableForm

  # TODO: add error messages

  attr_accessor :category_name, :category, :vehicle, :fitment_note, :user,
    :compatibility_search, :search_type

  validates :category_name, presence: true
  validates :vehicle, presence: true

  def initialize(params = {})
    @vehicle = find_vehicle(params[:vehicle])
    @category = find_category(params[:category])
    @category_name = params[:category].try(:[], :name)
    @fitment_note = find_fitment_note(params[:fitment_note]) if @category
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
    search_record.save
    search_record
  end
end
