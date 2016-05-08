class PartAttribute < ActiveRecord::Base
  belongs_to :parent


  scope :attribute_types, -> { where.not(parent_id: nil) }

  has_many :part_attribute_types, :class_name => "PartAttribute", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "'PartAttribute'", :foreign_key=>"parent_id"

  validates :name, presence: true
end
