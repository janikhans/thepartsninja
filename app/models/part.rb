class Part < ApplicationRecord
  # TODO
  # Eventually every part should require a part_number - Maybe
  # asssociated table with part_numbers from various suppliers
  # this part_number is the OEM supplied part_number
  # part_number is required if no associated vehicles exist
  # uniqueness on part_number and product_id
  # uniqueness on EPID

  extend FriendlyId
  friendly_id :part_number, use: [:finders]

  validates :product, presence: true
  belongs_to :product
  validates_uniqueness_of :epid,
    if: 'epid.present?',
    allow_blank: true

  belongs_to :user
  has_many :fitments, dependent: :destroy
  has_many :oem_vehicles,
    through: :fitments,
    source: :vehicle

  has_many :part_attributions, dependent: :destroy
  has_many :part_attributes,
    through: :part_attributions,
    source: :part_attribute
  accepts_nested_attributes_for :part_attributions,
    reject_if: :all_blank,
    allow_destroy: true

  has_many :fitment_notes,
    -> { distinct },
    through: :fitments

  has_many :compatibilities, dependent: :destroy

  def to_label
    "#{product.brand.name} #{product.category.name} #{product.name} #{part_number}"
  end

  def update_fitments_from_ebay
    return unless epid
    ebay_detail = Yaber::Product.fitments_for(epid)

    ebay_detail.fitments.each do |f|
      submodel = f[:submodel] unless f[:submodel] == '--'
      vehicle = Vehicle.find_with_specs(f[:make], f[:model], f[:year], submodel)
      if vehicle
        fitment = Fitment.where(vehicle_id: vehicle.id, part_id: id, source: 'ebay').first_or_initialize
        fitment.update_attribute(:note, f[:note])
      else
        vehicle = VehicleForm.new(brand: f[:make], model: f[:model], year: f[:year], submodel:  submodel, type: 'Motorcycle')
        if vehicle.valid?
          vehicle.save
          Fitment.create(vehicle_id: vehicle.vehicle.id, part_id: id, source: 'ebay')
        end
      end
    end
    update_attributes(ebay_fitments_imported: true,
                      ebay_fitments_updated_at: Time.now)
  end
end
