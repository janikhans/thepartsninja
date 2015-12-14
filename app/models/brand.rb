class Brand < ActiveRecord::Base

  has_many :vehicles
  has_many :parts
  before_validation :strip_and_upcase_name
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "brand already exists" }

  private

    def strip_and_upcase_name
      self.name = name.strip
      self.name = name[0].upcase + name[1..-1]
    end

end
