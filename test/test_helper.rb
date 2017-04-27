ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fivemat/minitest'
require 'capybara/rails'
require 'pry'

class ActiveSupport::TestCase
  fixtures :all
end

class IntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Warden::Test::Helpers
  include AuthenticationMethods

  setup do
    Capybara.reset_sessions!
  end

  teardown do
    Capybara.use_default_driver
  end
end

class UnitTest < ActiveSupport::TestCase

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
