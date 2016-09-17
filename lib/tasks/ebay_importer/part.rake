require 'csv'

namespace :ebay_import do

  desc "Import parts from Ebay Parts CSV"
  task :parts, [:file_path] => [:environment] do |t, args|
    filename = File.join Rails.root, args[:file_path]
    counter = 0
    invalids = 0
    start_time = Time.now
    CSV.foreach(filename, headers: true) do |row|
      category_breadcrumb = row["Category Breadcrumb"].split(":")
      parent_category = category_breadcrumb[2]
      category = category_breadcrumb[3]
      subcategory = category_breadcrumb[4]
      attributes =
      note = row["RESERVED_PRODUCT_TITLE"]
      part = EbayPartImportForm.new(brand: row["Part Brand"], product_name: row["Part Type"],
                          part_number: row["Part number"], epid: row["ePID"],
                          parent_category: parent_category, category: category,
                          subcategory: subcategory, note: note)
      # if vehicle.valid?
      #   if vehicle.save
      #     counter += 1
      #   else
      #     invalids += 1
      #   end
      # else
      #   invalids += 1
      #   puts "#{row["Year"]} #{row["Make"]} #{row["Model"]} - #{vehicle.errors.full_messages.join(",")}"
      # end
    end
    end_time = Time.now
    total_time = end_time - start_time
    puts "It took #{total_time} seconds to import #{counter} parts"
    puts "There were #{invalids} invalid parts"
  end
end

namespace :thing do
  desc "it does a thing"
  task :work, [:option] => [:environment] do |t, args|
    puts args
    puts args[:option]
  end
end
