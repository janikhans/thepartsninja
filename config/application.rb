require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Raven.configure do |config|
  config.dsn = "#{ENV['SENTRY_DSN']}"
  config.environments = ['production']
end

module Thepartsninja
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/test/modules)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths = %W(#{config.root}/app)
  end
end
