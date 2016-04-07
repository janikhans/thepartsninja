class Vehicle < ActiveRecord::Base

  #Lets make those URLs nice and SEO friendly
  extend FriendlyId
  friendly_id :slug_candidates, use: [:finders, :slugged]

  belongs_to :brand
  has_many :searches
  has_many :fitments
  has_many :oem_parts, through: :fitments, source: :part

  #Validations - woohoo!
  before_validation :sanitize_model
  validates :model, :brand, presence: true
  validates :year, presence: true,
                   numericality: true,
                   inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"},
                   uniqueness: {scope: [:brand_id, :model], message: "This model year already exists"}

  def brand_name
    brand.try(:name)
  end

  #This works but could be DRY'd with the same method from each model. Also doesn't allow for 2 companies with the same exact name.
  def brand_name=(name)
    name = name.strip
    self.brand = Brand.where('lower(name) = ?', name.downcase).first_or_create(name: name)
  end

  def to_label
    "#{year} #{brand.name} #{model}"
  end

private
  #This and the strip_and_upcase_name in brand.rb can be DRY'd up at some point
    def sanitize_model
      self.model = model.strip
      self.model = model[0].upcase + model[1..-1]
    end

    def slug_candidates
     [
      [:year, :brand_name, :model],
     ]
    end

end
