class Vehicle < ActiveRecord::Base
  belongs_to :brand

  validates :model, :brand, presence: true
  validates :year, presence: true, numericality: true, :inclusion => { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"}
  validates :year, uniqueness: {scope: [:brand_id, :model], message: "This model year already exists"}


  def brand_name
    brand.try(:name)
  end

  def brand_name=(name)
    self.brand = Brand.find_or_create_by(name: name) if name.present?
  end

end
