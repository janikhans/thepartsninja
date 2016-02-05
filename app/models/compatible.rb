class Compatible < ActiveRecord::Base
  # default_scope { order('score DESC') } 

  belongs_to :part
  belongs_to :compatible_part, class_name: "Part"
  belongs_to :discovery
  acts_as_votable

  def score
    self.get_upvotes.size - self.get_downvotes.size
  end
end
