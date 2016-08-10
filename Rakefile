# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Adding test/forms directory to rake test.
namespace :test do
  desc "Test tests/forms/* code"
  Rails::TestTask.new(forms: 'test:prepare') do |t|
    t.pattern = 'test/forms/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ["test:forms"]
