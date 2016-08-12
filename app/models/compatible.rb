class Compatible < ApplicationRecord
  # TODO change the :backward column attribute somehow. Maybe a second attribute
  # with an id to the other backwards:true reference?

  belongs_to :part
  validates :part, presence: true

  belongs_to :compatible_part, class_name: "Part"
  validates :compatible_part,
    presence: true,
    uniqueness: { scope: [:discovery_id, :part_id] }

  belongs_to :discovery
  validates :discovery, presence: true

  # TODO Make backwards_compatible into an after_create callback

  acts_as_votable

  def make_backwards_compatible
    return if self.backwards == false
    new_compat = self.dup
    new_compat.part, new_compat.compatible_part = new_compat.compatible_part, new_compat.part
    new_compat.save
    # Compatible.create(part: self.compatible_part, compatible_part: self.part, discovery: self.discovery, backwards: true)
  end
end
