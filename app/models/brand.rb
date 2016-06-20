class Brand < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]

  has_many :vehicle_models, inverse_of: :brand, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :products, dependent: :destroy
  before_validation :sanitize_name
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "brand already exists" }

  private

    def sanitize_name
      unless self.name.blank?
        self.name = name.strip
        self.name = name[0].upcase + name[1..-1]
      end
    end

end
