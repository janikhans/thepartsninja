class Product < ApplicationRecord
  # TODO potentially fix/remove these getter/setter methods.
  # Maybe the PartForm will replace all of this
  # slug should not include the brand in the future since the url will include it
  # when nested routes are used

  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  belongs_to :brand
  belongs_to :user
  belongs_to :category
  belongs_to :ebay_category
  belongs_to :product_type
  has_many :parts, dependent: :destroy
  has_many :part_attributes, -> { distinct }, through: :parts
  has_many :fitment_notes, -> { distinct }, through: :parts

  validates :name, :brand, :category, presence: true

  def brand_name
    brand.try(:name)
  end

  #This works but could create a duplicate in the case of TM Racing and TM racing
  def brand_name=(name)
    name = name.strip
    self.brand = Brand.where('lower(name) = ?', name.downcase).first_or_create(name: name)
  end

  def category_name
    brand.try(:name)
  end

  def category_name=(name)
    name = name.strip
    self.category = Category.where('lower(name) = ?', name.downcase).first_or_create(name: name)
  end

  def to_label
    "#{brand.name} - #{category.name} #{name}"
  end

  def slug_candidates
   [
    [:brand_name, :name],
   ]
  end

end
