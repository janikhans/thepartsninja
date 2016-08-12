class Profile < ApplicationRecord
  # TODO add more user profile attributes such as facebook, twitter, insta, etc
  # Should the profile store the users car-ma?

  belongs_to :user
  validates :user,
    presence: true,
    uniqueness: true

  validates :location, length: { maximum: 100 }
  validates :bio, length: { maximum: 200 }
end
