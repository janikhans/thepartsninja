namespace :ebay_importer do

  desc "Import fitments from Ebay API from category"
  task :fitments, [:category_id, :part_count] => [:environment] do |t, args|
    start_fitments = Fitment.count
    start_vehicles = Vehicle.count
    start_notations = FitmentNotation.count
    start_time = Time.now
    counter = 0

    category = Category.find(args[:category_id])

    parts = Part.joins(:product)
      .where('products.category_id = ? AND parts.ebay_fitments_imported = false', category.id)
      .order(product_id: :asc)
      .first(args[:part_count])

    parts.each do |part|
      part.update_ebay_fitments
      counter += 1

      if counter % 10 == 0
        puts "Imported fitments for #{counter} parts"
      end
    end

    finish_fitments = Fitment.count
    finish_vehicles = Vehicle.count
    finish_notations = FitmentNotation.count

    end_time = Time.now
    new_fitments = finish_fitments - start_fitments
    new_vehicles = finish_vehicles - start_vehicles
    new_notations = finish_notations - start_notations
    total_time = end_time - start_time
    puts "It took #{total_time} seconds to..."
    puts "Import #{new_fitments} fitments"
    puts "Create #{new_vehicles} new vehicles"
    puts "Create #{new_notations} new notations"
    puts "For #{counter} parts in category #{category.name}"
  end
end
