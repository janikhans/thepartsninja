class VehicleSubmodel < ActiveRecord::Base
  belongs_to :vehicle_model,
    inverse_of: :vehicle_submodels

  validates :vehicle_model,
    presence: true

  before_validation :sanitize_name
  validates :name,
    uniqueness: { scope: :vehicle_model_id, case_sensitive: false },
    if: 'name.present?'

  has_many :vehicles,
    inverse_of: :vehicle_submodel,
    dependent: :destroy

  accepts_nested_attributes_for :vehicles, reject_if: :all_blank

  private

    def sanitize_name
      unless self.name.blank?
        self.name = self.name.strip
        self.name = self.name[0].upcase + self.name[1..-1]
      end
    end
end
