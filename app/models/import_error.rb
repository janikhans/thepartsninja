class ImportError < ApplicationRecord
  validates :row, presence: true
  validates :import_errors, presence: true
end
