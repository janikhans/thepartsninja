class Discovery < ActiveRecord::Base
  belongs_to :user
  has_many :compatibles
  has_many :steps
  accepts_nested_attributes_for :compatibles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
end
