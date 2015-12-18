class Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :user
  has_many :parts, dependent: :destroy

  validates :name, :brand, presence: true

  def brand_name
    brand.try(:name)
  end

  #This works but could create a duplicate in the case of TM Racing and TM racing
  def brand_name=(name)
    name = name.strip
    self.brand = Brand.where('lower(name) = ?', name.downcase).first_or_create(name: name)
  end
  
end
