namespace :heroku_scheduler do
  desc 'Updates the AvailableFitmentNote materialized view table'
  task refresh_materialized_views: :environment do
    AvailableFitmentNote.refresh
  end

  desc 'Updates Category bool attributes'
  task update_category_bools: :environment do
    Category.refresh_leaves
    Category.refresh_fitment_notables
  end
end
