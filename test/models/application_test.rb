require "test_helper"

class ApplicationTest < UnitTest
  test "all models should inherit from ApplicationRecord" do
    application_record = ApplicationRecord.descendants
    active_record = ActiveRecord::Base.descendants

    blacklist = [ApplicationRecord, ActiveRecord::SchemaMigration]
    uninherited = active_record.reject { |a| application_record.include?(a) || blacklist.include?(a) }

    assert uninherited.empty?,
           "The following models do not inherit from ApplicationRecord:\n\t#{uninherited.join("\n\t")}"
  end

  test "all fixtures should be valid" do
    invalids = find_all_invalid_fixtures
    assert invalids.empty?,
           "The following are invalid:\n\t#{invalids.join("\n\t")}"
  end

  def find_all_invalid_fixtures
    fixtures = Dir.glob("test/fixtures/*.yml")
    fixtures.map! { |f| File.basename f, ".yml" }
    fixtures.map! { |f| f.classify.constantize }

    invalids = []
    fixtures.each do |f|
      invalids << find_invalid_fixtures_for(f)
    end

    invalids.flatten!
  end

  def find_invalid_fixtures_for(klass)
    invalid_fixtures = klass.all.reject(&:valid?)
    offending_fixtures = []
    unless invalid_fixtures.empty?
      invalid_fixtures.each do |i|
        attributes = i.attributes.symbolize_keys.except!(:id, :created_at, :updated_at)
        offending_fixtures << "[#{i.class.name}, #{attributes}, #{i.errors.full_messages}]"
      end
    end
    offending_fixtures
  end
end
