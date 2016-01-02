class Discovery < ActiveRecord::Base
  belongs_to :user
  has_many :compatibles, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :fitments, through: :compatibles, source: :fitment
  has_many :compatible_fitments, through: :compatibles, source: :compatible_fitment
  accepts_nested_attributes_for :compatibles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :steps, reject_if: :all_blank, allow_destroy: true
end
