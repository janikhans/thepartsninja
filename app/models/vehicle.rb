class Vehicle < ActiveRecord::Base
  belongs_to :brand

  before_validation :strip_and_upcase_model
  validates :model, :brand, presence: true
  validates :year, presence: true, 
                   numericality: true, 
                   inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"}, 
                   uniqueness: {scope: [:brand_id, :model], message: "This model year already exists"}


  def brand_name
    brand.try(:name)
  end

  #This works but could create a duplicate in the case of TM Racing and TM racing
  def brand_name=(name)
    name = name.strip
    name = name[0].upcase + name[1..-1]
    self.brand = Brand.find_or_create_by(name: name) if name.present?
  end


private
  #This and the strip_and_upcase_name in brand.rb can be DRY'd up at some point
    def strip_and_upcase_model
      self.model = model.strip
      self.model = model[0].upcase + model[1..-1]
    end

end
