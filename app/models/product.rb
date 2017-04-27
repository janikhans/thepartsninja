class Product < ApplicationRecord
  # TODO: potentially fix/remove these getter/setter methods.
  # Maybe the PartForm will replace all of this
  # slug should not include the brand in the future since the url will include it
  # when nested routes are used

  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  belongs_to :brand
  belongs_to :user
  belongs_to :category
  belongs_to :ebay_category
  has_many :parts, dependent: :destroy
  has_many :part_attributes, -> { distinct }, through: :parts
  has_many :fitment_notes, -> { distinct }, through: :parts

  validates :name, :brand, presence: true

  validates :category,
    presence: true,
    if: 'ebay_category_id.nil?'

  validates :ebay_category,
    presence: true,
    if: 'category_id.nil?'

  def to_label
    "#{brand.name} - #{category.name} #{name}"
  end

  def brand_name
    brand.name
  end

  def slug_candidates
    [
      [:brand_name, :name]
    ]
  end

end
