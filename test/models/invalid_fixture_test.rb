require 'test_helper'

class InvalidFixtureTest < ActiveSupport::TestCase
  test 'all fixtures should be valid' do
    invalids = find_all_invalid_fixtures
    assert invalids.empty?,
      "The following fixtures are invalid:\n\t#{invalids.join("\n\t")}"
  end

  def find_all_invalid_fixtures
    Dir.glob('test/fixtures/*.yml')
       .map { |f| File.basename f, '.yml' }
       .map { |f| f.classify.constantize }
       .reduce([]) { |a, e| a << find_invalid_fixtures_for(e) }
       .flatten
  end

  def find_invalid_fixtures_for(klass)
    invalid_fixtures = klass.all.reject(&:valid?)
    invalid_fixtures.map do |i|
      "#{i.class.name} with errors \"#{i.errors.full_messages.join(', ')}\" and
        attributes #{attributes_for(i)}"
    end
  end

  def attributes_for(fixture)
    fixture.attributes.symbolize_keys.except!(:id, :created_at, :updated_at)
  end
end
