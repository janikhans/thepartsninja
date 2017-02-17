class CompatibilityCheck
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  # TODO add validations and error callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "CompatibilityCheck")
  end

  attr_accessor :category_name, :category_id, :vehicles, :fitment_note_id, :fitment_note_name, :part_attributes,
    :vehicle_one_brand, :vehicle_one_model, :vehicle_one_submodel, :vehicle_one_year,
    :vehicle_two_brand, :vehicle_two_model, :vehicle_two_submodel, :vehicle_two_year
  attr_reader :compatible_parts, :vehicles, :category, :category_name, :part_attributes, :fitment_note

  # before_validation :sanitize_fields
  validates :category_name, presence: true
  validate :validate_vehicles

  def initialize(params = {})
    @vehicles = find_vehicles(params[:vehicles])
    @category = set_category(params)
    @category_name = params[:category_name]
    @fitment_note = set_fitment_note(params)
    # FIXME temp hack because rails form sends an empty param through the form
    # @part_attribute_ids = params[:part_attributes].delete_if { |x| x.empty? }
    @part_attributes = PartAttribute.where(id: @part_attribute_ids) unless @part_attribute_ids.blank?
    @compatible_parts = []
  end

  def process(current_user = nil)
    return false unless valid?
    CheckSearch.create(vehicle: @vehicles.first, comparing_vehicle: @vehicles.second, category: @category, category_name: @category_name, user: current_user)
    return false unless @category.present?
    @compatible_parts = find_compatible_parts
  end

  private

    # FIXME this isn't working right. Need to show records that have have common vehicle.id
    def find_compatible_parts_sql
      return false if @vehicles.blank? || @category.blank?
      compatible_parts = Part.joins(:product, :fitments).where('products.category_id = ? AND fitments.vehicle_id IN (?)', @category.id, @vehicles.pluck(:id))
      compatible_parts = compatible_parts.joins(:fitment_notes).where('fitment_notes.id = ?', @fitment_note.id) if @fitment_note.present?
      compatible_parts = compatible_parts.joins(:part_attributes).where('part_attributes.id IN (?)', @part_attributes.pluck(:id)) if @part_attributes.present?
      compatible_parts = compatible_parts.select("DISTINCT parts.*").includes(product: :brand)
    end

    def find_compatible_parts
      return if @vehicles.blank? || @category.blank?
      vehicle_parts = []
      @vehicles.each do |vehicle|
        parts = vehicle.oem_parts.joins(:product).where('products.category_id = ?', @category.id)
        parts = parts.joins(:fitment_notes).where('fitment_notes.id = ?', @fitment_note.id) if @fitment_note.present?
        parts = parts.joins(:part_attributes).where('part_attributes.id IN (?)', @part_attribute.pluck(:id)) if @part_attributes.present?
        parts = parts.select("DISTINCT parts.*").includes(product: :brand)
        vehicle_parts << parts
      end
      compatible_parts = vehicle_parts.inject(:&)
    end

    def set_category(params)
      if params[:category_id].present?
        category = Category.find_by_id(params[:category_id])
        # self.errors.add :category, 'We were unable to find a category with that ID' if category.nil?
      elsif params[:category_name].present?
        # Currently set so we're only using the Motrycycle Parts category Category.id => 1
        category = Category.first.descendants.leaves.where('lower(name) = ?', params[:category_name].downcase).first
        # self.errors.add :category, 'We were unable to find a category with that name' if category.nil?
      else
        # self.errors.add :category, 'Please specify a Category ID or Category Name'
      end
    end

    def set_fitment_note(params)
      if params[:fitment_note_id].present?
        FitmentNote.find_by_id(params[:fitment_note_id])
      elsif params[:fitment_note_name].present?
        FitmentNote.where('lower(name) = ?', params[:fitment_note_name].downcase).first
      else
        # return error
      end
    end

    def find_vehicles(vehicles_array)
      return if vehicles_array.blank? # should add error
      vehicles = []
      vehicles_array.each do |vehicle|
        if vehicle[:id].present?
          vehicles << Vehicle.find_by_id(vehicle[:id])
        elsif vehicle[:brand].present? && vehicle[:model].present? && vehicle[:year].present?
          vehicles << Vehicle.find_with_specs(vehicle[:brand],vehicle[:model],vehicle[:year])
        else
          # return error
        end
      end
      # TODO add error if both vehicles are the same
      return vehicles
    end

    def validate_vehicles
      if vehicles.nil? || vehicles.length < 2
        errors.add(:base, "Please select 2 vehicles")
      end
    end
end
