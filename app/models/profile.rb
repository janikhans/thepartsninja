class Profile < ActiveRecord::Base
  belongs_to :user

  validates :user,
    presence: true,
    uniqueness: true
  validates :location, length: { maximum: 100 }
  validates :bio, length: { maximum: 200 }
end
