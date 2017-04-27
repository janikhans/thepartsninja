class EbayProductForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Product')
  end

  attr_accessor :brand, :product_name, :root_category, :category, :subcategory,
    :product

  before_validation :sanitize_fields

  validates :brand, :product_name, :category, :root_category,
    length: { maximum: 100 },
    presence: true

  def save
    return false unless valid?
    product_brand = find_or_create_brand
    root_cat = find_or_create_root_category
    cat = find_or_create_category(root_cat)
    subcat = find_or_create_subcategory(cat)
    self.product = find_or_create_product(subcat, product_brand)
  end

  private

  def sanitize_fields
    self.brand = sanitize(brand)
    self.product_name = sanitize(product_name)
    self.root_category = sanitize(root_category)
    self.category = sanitize(category)
    self.subcategory = sanitize(subcategory)
  end

  def sanitize(field)
    return if field.blank?
    field = field.strip
    field[0].upcase + field[1..-1]
  end

  def find_or_create_brand
    Brand.where('lower(name) = ?', brand.downcase).first_or_create!(name: brand)
  end

  def find_or_create_root_category
    EbayCategory.roots.where('lower(name) = ?', root_category.downcase)
                .first_or_create!(name: root_category)
  end

  def find_or_create_category(root_category)
    root_category.children.where('lower(name) = ?', category.downcase)
                 .first_or_create!(name: category)
  end

  def find_or_create_subcategory(category)
    if subcategory
      category.children.where('lower(name) = ?', subcategory.downcase)
              .first_or_create!(name: subcategory)
    else
      category
    end
  end

  def find_or_create_product(category, brand)
    brand.products.where('lower(name) = ? AND ebay_category_id = ?',
      product_name.downcase, category.id)
         .first_or_create!(name: product_name, ebay_category: category)
  end
end
