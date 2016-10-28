namespace :ebay_update do

  desc "Update fitments from Ebay API from category"
  task :fitments, [:category_id, :part_count] => [:environment] do |t, args|
    start_fitments = Fitment.count
    nil_note_fitments = Fitment.where.not(note: nil).count
    start_time = Time.now
    counter = 0

    if args[:category_id] == "0"
      parts = Part.where('ebay_fitments_imported is TRUE AND ebay_fitments_updated_at IS NULL')
        .first(args[:part_count])
    else
      category = Category.find(args[:category_id])

      parts = Part.joins(:product)
        .where('products.category_id = ? AND parts.ebay_fitments_updated_at IS NULL', args[:category_id])
        .order(product_id: :asc)
        .first(args[:part_count])
    end


    parts.each do |part|
      part.update_fitments_from_ebay
      counter += 1

      if counter % 10 == 0
        puts "Updated fitments for #{counter} parts"
      end
    end

    finish_fitments = Fitment.count
    finished_nil_note_fitments = Fitment.where.not(note: nil).count

    end_time = Time.now
    new_fitments = finish_fitments - start_fitments
    updated_fitments = finished_nil_note_fitments - nil_note_fitments
    total_time = end_time - start_time
    puts "Updating completed in #{total_time} seconds"
    puts "Added #{new_fitments} fitments"
    puts "Updated notes for #{updated_fitments} fitments"
    puts "For #{counter} parts"
    puts "In category #{category.name}" if category
  end
end
