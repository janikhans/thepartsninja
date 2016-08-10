class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  belongs_to :brand
  belongs_to :user
  belongs_to :category
  has_many :parts, dependent: :destroy

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
