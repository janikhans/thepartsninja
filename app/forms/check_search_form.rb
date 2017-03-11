class CheckSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  # TODO add validations and error callbacks

  attr_accessor :category, :category_name, :vehicle, :comparing_vehicle, :user, :check_search, :fitment_note

  validates :category_name, presence: true
  validates :vehicle, presence: true
  validates :comparing_vehicle, presence: true

  def initialize(params = {})
    return if params.blank?
    @vehicle = set_vehicle(params[:vehicle])
    @comparing_vehicle = set_vehicle(params[:comparing_vehicle])
    @category = set_category(params[:category])
    @category_name = params[:category][:name]
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

    def set_category(params)
      return nil if params.blank?
      if params[:id].present?
        Category.find_by(id: params[:id])
      elsif params[:name].present?
        # Currently set so we're only using the Motrycycle Parts category Category.id => 1
        Category.first.descendants.leaves.where('lower(name) = ?', params[:name].downcase).first
      else
        # return error
      end
    end

    def set_fitment_note(params)
      return nil if params.blank?
      if params[:id].present?
        FitmentNote.find_by(id: params[:id])
      elsif params[:name].present?
        FitmentNote.where('lower(name) = ?', params[:name].downcase).first
      else
        # return error
      end
    end

    def set_vehicle(params)
      return nil if params.blank? # should add error
      if params[:id].present?
        vehicle = Vehicle.find_by(id: params[:id])
      elsif params[:brand].present? && params[:model].present? && params[:year].present?
        vehicle = Vehicle.find_with_specs(params[:brand],params[:model],params[:year])
      else
        # return error
      end
    end
end
