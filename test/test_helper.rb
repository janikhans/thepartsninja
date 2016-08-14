ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fivemat/minitest'
require 'capybara/rails'
require 'pry'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.


  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

class UnitTest < ActiveSupport::TestCase
  fixtures :all
  # def self.assert_all_fixtures_valid(klass)
  #   invalids = klass.all.reject { |k| k.valid? }
  #   assert invalids.empty?, "The following are invalid:\n\t #{invalids.join("\n\t")}"
  # end

  def self.find_all_invalid_fixtures
    fixtures = Dir.glob("test/fixtures/*.yml")
    fixtures.map! { |f| File.basename f, ".yml"}
    fixtures.map! { |f| f.classify.constantize }

    fixtures.each do |f|
      assert_all_fixtures_valid(f)
    end
  end

  def self.assert_all_fixtures_valid(klass)
    invalids = klass.all.reject { |k| k.valid? }
    unless invalids.empty?
      puts "\n--------------------\nThe following #{klass} fixtures are invalid:\n\n"
      invalids.each do |i|
        puts "\tid: #{i.id}, #{i.errors.full_messages}"
      end
      # puts "\n--------------------"
    end
  end

  def assert_differences(expression_array, message = nil, &block)
    b = block.send(:binding)
    before = expression_array.map { |expr| eval(expr[0], b) }

    yield

    expression_array.each_with_index do |pair, i|
      e = pair[0]
      difference = pair[1]
      error = "#{e.inspect} didn't change by #{difference}"
      error = "#{message}\n#{error}" if message
      assert_equal(before[i] + difference, eval(e, b), error)
    end
  end
end
