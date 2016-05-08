class PartTrait < ActiveRecord::Base
  belongs_to :Part
  belongs_to :PartAttribute
end
