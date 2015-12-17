class Part < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_many :fitments
  has_many :vehicles, through: :fitments

  validates :product, presence: true
end
