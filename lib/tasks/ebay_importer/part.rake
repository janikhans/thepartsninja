require 'csv'

namespace :ebay_import do

  desc "Import parts from Ebay Parts CSV"
  task parts: :environment do
    filename = File.join Rails.root, "ebay_parts_test.csv"
    counter = 0
    invalids = 0
    start_time = Time.now
    CSV.foreach(filename, headers: true) do |row|
      binding.pry
      # submodel = row["Submodel"] unless row["Submodel"] == "--"
      part = PartForm.new(brand: row["Part Brand"], product_name: row["Part Type"],
                          part_number: row["Part number"], epid: row["ePID"])
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
