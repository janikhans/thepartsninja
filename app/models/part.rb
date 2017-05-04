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

  def update_ebay_fitments
    return unless epid
    ebay_detail = Yaber::YaberProduct.fitments_for(epid)

    ebay_detail.fitments.each do |f|
      submodel = f[:submodel] unless f[:submodel] == '--'
      vehicle = Vehicle.find_with_specs(f[:make], f[:model], f[:year], submodel)
      ActiveRecord::Base.transaction do
        unless vehicle
          vehicle_form = VehicleForm.new(vehicle_brand: f[:make],
                                         vehicle_model: f[:model],
                                         vehicle_year: f[:year],
                                         vehicle_submodel: submodel,
                                         vehicle_type: 'TBD')
          next unless vehicle_form.find_or_create
          vehicle = vehicle_form.vehicle
        end
        fitment = Fitment.where(vehicle_id: vehicle.id,
                                part_id: id,
                                source: 'ebay')
                         .first_or_initialize
        fitment.note = f[:note]
        fitment.save

        if fitment.note.present?
          fitment_notes = fitment.note.split('; ').map(&:strip)
          notes = FitmentNote.individual_notes
                             .where(name: fitment_notes)
          notes.each do |note|
            note.fitment_notations.where(fitment: fitment).first_or_create
          end
        end
      end
    end
    self.ebay_fitments_imported = true
    self.ebay_fitments_updated_at = Time.current
    save
  end
end
