namespace :ebay_import do

  desc "Import fitments from Ebay API from category"
  task :fitments, [:category_id, :part_count] => [:environment] do |t, args|
    start_fitments = Fitment.count
    start_time = Time.now
    counter = 0

    category = Category.find(args[:category_id])

    parts = Part.joins(:product)
      .where('products.category_id = ? AND parts.ebay_fitments_imported = false', args[:category_id])
      .order(product_id: :asc)
      .first(args[:part_count])

    parts.each do |part|
      part.update_fitments_from_ebay
      counter += 1

      if counter % 10 == 0
        puts "Imported fitments for #{counter} parts"
      end
    end

    finish_fitments = Fitment.count
    end_time = Time.now
    new_fitments = finish_fitments - start_fitments
    total_time = end_time - start_time
    puts "It took #{total_time} seconds to import #{new_fitments} fitments for #{counter} parts in category #{category.name}"
  end
end
