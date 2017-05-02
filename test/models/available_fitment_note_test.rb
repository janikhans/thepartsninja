require 'test_helper'

class AvailableFitmentNoteTest < ActiveSupport::TestCase
  should belong_to(:category)
  should belong_to(:fitment_note)
end
