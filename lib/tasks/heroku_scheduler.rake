namespace :heroku_scheduler do
  desc 'Updates the AvailableFitmentNote materialized view table'
  task refresh_materialized_views: :environment do
    AvailableFitmentNote.refresh
  end

  desc 'Updates Category#leaves attributes'
  task update_category_leaves: :environment do
    Category.refresh_leaves
  end
end
