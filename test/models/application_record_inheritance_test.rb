require 'test_helper'

class ApplicationRecordInheritanceTest < ActiveSupport::TestCase

  test "all models should inherit from ApplicationRecord" do
    application_records = ApplicationRecord.descendants
    active_records = ActiveRecord::Base.descendants

    blacklist = [ApplicationRecord, ActiveRecord::SchemaMigration, ActsAsVotable::Vote]
    uninherited = active_records - application_records - blacklist

    assert uninherited.empty?,
      "The following models do not inherit from ApplicationRecord:\n\t#{uninherited.join("\n\t")}"
  end
end
