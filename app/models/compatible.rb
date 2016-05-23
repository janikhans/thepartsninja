class Compatible < ActiveRecord::Base

  belongs_to :part
  belongs_to :compatible_part, class_name: "Part"
  belongs_to :discovery
  acts_as_votable

  def make_backwards_compatible
    return if self.backwards == false
    new_compat = self.dup
    new_compat.part, new_compat.compatible_part = new_compat.compatible_part, new_compat.part
    new_compat.save
  end

end
