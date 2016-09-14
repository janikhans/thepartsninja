class ProductForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, "Product")
  end

  attr_accessor :brand, :product_name, :parent_category, :category, :subcategory, :user
  attr_reader :product

  before_validation :sanitize_fields

  validates :brand, :product_name, :category, :parent_category,
    length: { maximum: 75 },
    presence: true

  def save
    if valid?
      brand = Brand.where('lower(name) = ?', @brand.downcase).first_or_create!(name: @brand)
      parent_category = Category.where('lower(name) = ? AND parent_id IS ?', @parent_category.downcase, nil).first_or_create!(name: @parent_category, parent_id: nil)
      category = parent_category.subcategories.where('lower(name) = ?', @category.downcase).first_or_create!(name: @category)
      if @subcategory
        subcategory = category.subcategories.where('lower(name) = ?', @subcategory.downcase).first_or_create!(name: @subcategory)
      else
        subcategory = category
      end
      @product = brand.products.where('lower(name) = ? AND category_id = ?', @product_name.downcase, subcategory.id).first_or_create!(name: @product_name, category: subcategory, user: @user)
    else
      false
    end
  end

  private

  def sanitize_fields
    @brand = sanitize(@brand)
    @product_name = sanitize(@product_name)
    @parent_category = sanitize(@parent_category)
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
