ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fivemat/minitest'
require "capybara/rails"

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
end
