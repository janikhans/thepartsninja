require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase

  test "all models should inherit from ApplicationRecord" do
    application_records = ApplicationRecord.descendants
    active_records = ActiveRecord::Base.descendants

    blacklist = [ApplicationRecord, ActiveRecord::SchemaMigration, ActsAsVotable::Vote]
    uninherited = active_records - application_records - blacklist

    assert uninherited.empty?,
      "The following models do not inherit from ApplicationRecord:\n\t#{uninherited.join("\n\t")}"
  end

  test "all fixtures should be valid" do
    invalids = find_all_invalid_fixtures
    assert invalids.empty?, "The following fixtures are invalid:\n\t#{invalids.join("\n\t")}"
  end

  def find_all_invalid_fixtures
    fixture_classes = Dir.glob("test/fixtures/*.yml")
      .map { |f| File.basename f, ".yml" }
      .map { |f| f.classify.constantize }
      .reduce([]) { |invalids, f| invalids << find_invalid_fixtures_for(f) }
      .flatten
  end

  def find_invalid_fixtures_for(klass)
    invalid_fixtures = klass.all.reject(&:valid?)
    invalid_fixtures.map do |i|
      "#{i.class.name} with errors \"#{i.errors.full_messages.join(", ")}\" and attributes #{attributes_for(i)}"
    end
  end

  def attributes_for(fixture)
    fixture.attributes.symbolize_keys.except!(:id, :created_at, :updated_at)
  end
end
