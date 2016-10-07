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

  attr_accessor :brand, :product_name, :parent_category, :category,
                :subcategory, :part_number, :vehicle, :attributes
  attr_reader :part, :product, :vehicle

  before_validation :sanitize_fields

  validates :brand, :product_name, :parent_category, :category, :subcategory,
    length: { maximum: 75 },
    presence: true

  validates :part_number,
    presence: true,
    if: 'vehicle.blank?'

  validates :part_number,
    length: { maximum: 75 }

  def save
    if valid?
      @product = ProductForm.new(brand: @brand, product_name: @product_name, parent_category: @parent_category, category: @category, subcategory: @subcategory).save
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
        @part = @product.parts.where('lower(part_number) = ?', @part_number.downcase).first_or_create!(part_number: part_number)
      end
      if @attributes
        @attributes.each do |a|
          parent_attribute = PartAttribute.where('lower(name) = ?', a[:parent_attribute].downcase).first_or_create!(name: a[:parent_attribute])
          part_attribute = parent_attribute.attribute_variations.where('lower(name) = ?', a[:attribute].downcase).first_or_create!(name: a[:attribute])
          part_attribution = @part.part_attributions.create(part_attribute: part_attribute)
        end
      end
    else
      return false
    end
  end

  private

  def sanitize_fields
    @brand = sanitize(@brand)
    @product_name = sanitize(@product_name)
    @parent_category = sanitize(@parent_category)
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
end
