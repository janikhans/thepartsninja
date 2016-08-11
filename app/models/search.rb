class Search < ActiveRecord::Base
  belongs_to :user
  belongs_to :vehicle

  # TODO need validations in here for some cases
  # Also potentially add a part_id column
  # also a submodel field, potentially a vehicle_type too
end
