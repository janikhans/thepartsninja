class PartAttribute < ActiveRecord::Base
  belongs_to :parent
  has_many :part_traits, dependent: :destroy

  scope :specific_attribute, -> { where.not(parent_id: nil) }
  scope :attribute_parents, -> { where(parent_id: nil) }

  has_many :attribute_variations, :class_name => "PartAttribute", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "'PartAttribute'", :foreign_key=>"parent_id"

  validates :name, presence: true
end