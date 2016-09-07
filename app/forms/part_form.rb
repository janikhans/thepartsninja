class PartForm
  # TODO how should we validate vehicle object?
  # Search by part_number FIRST, if more than one results exist, continue until unique
  # Make sure that product, part_number and vehicle all match up.
  # needs to be able to take part traits, and multiples of them
  # needs to take multiple vehicles

  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Part")
  end

  attr_accessor :brand, :product_name, :category, :subcategory, :part_number, :vehicle, :epid
  attr_reader :part, :product, :vehicle

  before_validation :sanitize_fields, :sanitize_to_integer
  before_validation :part_epid_is_unique, if: 'epid.present?'

  validates :brand, :product_name, :category, :subcategory,
    length: { maximum: 75 },
    presence: true

  validates :part_number,
    presence: true,
    if: 'vehicle.blank?'

  validates :part_number,
    length: { maximum: 75 }

  def save
    if valid?
      @product = ProductForm.new(brand: @brand, product_name: @product_name, category: @category, subcategory: @subcategory).save
      if @vehicle
        if @part_number
          existing_oem_part = @vehicle.oem_parts.where('lower(part_number) = ? AND product_id = ?', @part_number.downcase, @product.id).first
          if existing_oem_part
            @part = existing_oem_part
          else
            @part = @product.parts.where('lower(part_number) = ?', @part_number.downcase).first_or_create!(part_number: @part_number)
            @part.fitments.create(vehicle: @vehicle)
          end
        else
          @part = @product.parts.create(part_number: nil)
          @part.fitments.create(vehicle: @vehicle)
        end
      else
        @part = @product.parts.where('lower(part_number) = ?', @part_number.downcase).first_or_create!(part_number: part_number, epid: @epid)
      end
    else
      return false
    end
  end

  private

  def sanitize_to_integer
    @epid = @epid.to_i if @epid.is_a? String
  end

  def sanitize_fields
    @brand = sanitize(@brand)
    @product_name = sanitize(@product_name)
    @category = sanitize(@category)
    @subcategory = sanitize(@subcategory)
    @part_number = sanitize(@part_number)
  end

  def sanitize(field)
    unless field.blank?
      field = field.strip
      field = field[0].upcase + field[1..-1]
    end
  end

  def part_epid_is_unique
    unless Part.where(epid: @epid).count == 0
      errors.add(:epid, 'Part with this epid already exists')
    end
  end
end
