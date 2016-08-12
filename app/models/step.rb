class Step < ApplicationRecord
  # TODO Steps should accept comments - possibly
  # should have markdown parsing ability

  belongs_to :discovery
  validates :discovery, presence: true

  validates :content, presence: true
end
