namespace :heroku_scheduler do
  desc 'Updates the AvailableFitmentNote materialized view table'
  task refresh_materialized_views: :environment do
    AvailableFitmentNote.refresh
  end
end
