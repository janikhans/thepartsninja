class Discovery < ActiveRecord::Base
  belongs_to :user
  has_many :compatibles, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :parts, through: :compatibles, source: :part
  has_many :compatible_parts, through: :compatibles, source: :compatible_part
  accepts_nested_attributes_for :compatibles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true

  #Work around so that the discovery form validates and saves info in case it's wrong
  attr_accessor :oem_part_brand
  attr_accessor :oem_part_name
  attr_accessor :oem_vehicle_brand
  attr_accessor :oem_vehicle_year
  attr_accessor :oem_vehicle_model
  attr_accessor :compatible_vehicle_brand
  attr_accessor :compatible_vehicle_year
  attr_accessor :compatible_vehicle_model
  attr_accessor :compatible_part_name
  attr_accessor :compatible_part_brand
  attr_accessor :backwards

  # validates :oem_part_brand, :oem_part_name, :compatible_vehicle_brand, :compatible_vehicle_model, :compatible_part_name, :compatible_part_brand, presence: true
  # validates :compatible_vehicle_year, presence: true, numericality: true #, inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"}
  # validates :oem_vehicle_year, numericality: true, allow_blank: true#, inclusion: { in: 1900..Date.today.year+1, message: "needs to be between 1900-#{Date.today.year+1}"}

end
