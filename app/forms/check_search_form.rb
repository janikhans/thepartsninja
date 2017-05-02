class CheckSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include SearchableForm

  # TODO: add error callbacks

  attr_accessor :category, :category_name, :vehicle, :comparing_vehicle,
    :user, :check_search, :fitment_note, :terms_of_service

  validates :category_name, presence: true
  validates_presence_of :vehicle, message: 'must be selected'
  validates_presence_of :comparing_vehicle, message: 'must be selected'

  validates :terms_of_service,
    acceptance: true,
    if: 'user.nil?'

  def initialize(params = {})
    @vehicle = find_vehicle(params[:vehicle])
    @comparing_vehicle = find_vehicle(params[:comparing_vehicle])
    @category = find_category(params[:category])
    @category_name = params[:category].try(:[], :name)
    @fitment_note = find_fitment_note(params[:fitment_note]) if @category
    @user = nil
    @terms_of_service = false || (params[:terms_of_service] == '1')
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
    search_record.save
    search_record
  end
end
