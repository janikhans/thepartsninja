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
    name = name[0].upcase + name[1..-1]
    self.brand = Brand.find_or_create_by(name: name) if name.present?
  end
  
end
