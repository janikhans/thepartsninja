class Discovery < ActiveRecord::Base
  belongs_to :user
  has_many :compatibles
end
