class Step < ActiveRecord::Base
  belongs_to :discovery
  validates :discovery, presence: true

  validates :content, presence: true
end
