class PartTrait < ActiveRecord::Base
  belongs_to :part
  belongs_to :part_attribute
end
