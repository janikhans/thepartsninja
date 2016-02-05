class Compatible < ActiveRecord::Base

  belongs_to :part
  belongs_to :compatible_part, class_name: "Part"
  belongs_to :discovery
  acts_as_votable

end
