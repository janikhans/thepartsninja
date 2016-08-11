class Brand < ActiveRecord::Base
  # TODO brand will eventually need some attribute to show if it's a
  # vehicle manufacturer, part manufacturer and/or both
  # Potentially an ebay ID
  # potentially a user_id if it's added by a user
  # attribute for brand description, social media sites?
  # let a brand create an account and get special access?

  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]

  has_many :vehicle_models,
    inverse_of: :brand,
    dependent: :destroy

  has_many :vehicles,
    through: :vehicle_models

  has_many :products,
    dependent: :destroy

  before_validation :sanitize_name
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: false, message: "brand already exists" }

  private

    def sanitize_name
      unless self.name.blank?
        self.name = self.name.strip
        self.name = self.name[0].upcase + self.name[1..-1]
      end
    end

end
