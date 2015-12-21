class Compatible < ActiveRecord::Base
  belongs_to :user
  belongs_to :fitment
  belongs_to :compatible_fitment, class_name: "Fitment"
end
