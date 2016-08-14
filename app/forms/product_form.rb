class ProductForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Product")
  end

  attr_accessor :brand, :product_name, :category, :subcategory
  attr_reader :product

  before_validation :sanitize_fields

  validates :brand, :product_name, :category, :subcategory,
    length: { maximum: 75 },
    presence: true

  def save
    if valid?
      brand = Brand.where('lower(name) = ?', @brand.downcase).first_or_create!(name: @brand)
      category = Category.where('lower(name) = ? AND parent_id IS ?', @category.downcase, nil).first_or_create!(name: @category, parent_id: nil)
      subcategory = category.subcategories.where('lower(name) = ?', @subcategory.downcase).first_or_create!(name: @subcategory)
      @product = brand.products.where('lower(name) = ? AND category_id = ?', @product_name.downcase, subcategory.id).first_or_create!(name: @product_name, category: subcategory)
    else
      return false
    end
  end

  private

  def sanitize_fields
    @brand = sanitize(@brand)
    @product_name = sanitize(@product_name)
    @category = sanitize(@category)
    @subcategory = sanitize(@subcategory)
  end

  def sanitize(field)
    unless field.blank?
      field = field.strip
      field = field[0].upcase + field[1..-1]
    end
  end
end
