class CheckSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include SearchableForm

  # TODO add error callbacks

  attr_accessor :category, :category_name, :vehicle, :comparing_vehicle, :user, :check_search, :fitment_note

  validates :category_name, presence: true
  validates :vehicle, presence: true
  validates :comparing_vehicle, presence: true

  def initialize(params = {})
    @vehicle = set_vehicle(params[:vehicle])
    @comparing_vehicle = set_vehicle(params[:comparing_vehicle])
    @category = set_category(params[:category])
    @category_name = params[:category].try(:[], :name)
    @fitment_note = set_fitment_note(params[:fitment_note])
    @user = nil
  end

  def save
    return false unless valid?
    self.check_search = create_check_search
  end

  private

  def create_check_search
    search_record = CheckSearch.new(vehicle: @vehicle,
                              comparing_vehicle: @comparing_vehicle,
                              category: @category,
                              category_name: @category_name,
                              user: @user,
                              fitment_note: @fitment_note)
    search_record.process(eager_load: true)
    if search_record.successful?
      search_record.results_count = search_record.compatible_parts.first.results_count
    end
    search_record.save
    search_record
  end
end
