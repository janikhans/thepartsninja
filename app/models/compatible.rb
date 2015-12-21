class Compatible < ActiveRecord::Base
  belongs_to :user
  belongs_to :known, class_name: "Fitment"
  belongs_to :replaces, class_name: "Fitment"
end
