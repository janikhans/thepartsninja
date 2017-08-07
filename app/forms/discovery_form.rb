class DiscoveryForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  # Start with general first
  # Start with only known vehicle part compatibilities, deal with other parts later

  # Compatibility is between 2 fitments OR between 2 parts and 2 fitment_notes

  # Ask if general fitment. ie. I know this year wheel fits this year
  # - Need to know the general part (will be same for both vehicles)
  # - - General bool attribute on Product, product_name and brand will not be required
  # - - Part number will also be null, attrs still work. Potentially cache general bool
  # - Need to know vehicles, base and all that fit

  # Form to build Discovery that a part is compatible with another part.
  # V1 is the base vehicle and v2+ are the other known vehicles that fit
  # Cases
  # Case 1
  # A part is compatible between 2 vehicles. Only
  #
  # Need to know the vehicle that is compatible and the part

  attr_accessor :notes, :user, :v1, :v2,
    :p1_category, :p1_fitment_note,
    :p2_category, :p2_fitment_note

  validates :p1_category, :p1_fitment_note, :p2_category, :p2_fitment_note, :user,
    presence: true

  validates :v1, presence: { message: 'Base Vehicle must be selected' }
  validates :v2, presence: { message: 'Compatible Vehicle(s) must be selected' }

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do

    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
