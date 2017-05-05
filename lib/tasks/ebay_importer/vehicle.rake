require 'csv'

namespace :ebay_importer do

  desc "Import vehicles from Ebay Vehicles CSV"
  task :vehicles, [:file_path] => [:environment] do |t, args|
    filepath = File.join Rails.root, args[:file_path]
    counter = 0
    invalids = 0
    start_time = Time.now
    CSV.foreach(filepath, headers: true) do |row|
      submodel = row["Submodel"] unless row["Submodel"] == "--"
      vehicle = VehicleForm.new(brand: row["Make"], model: row["Model"],
                                submodel: submodel, year: row["Year"],
                                type: row["Vehicle Type"], epid: row["ePID"])
      if vehicle.valid?
        if vehicle.save
          counter += 1
        else
          invalids += 1
        end
      else
        invalids += 1
        puts "#{row["Year"]} #{row["Make"]} #{row["Model"]} - #{vehicle.errors.full_messages.join(",")}"
      end
      if counter % 10000 == 0
        puts "Imported #{counter} vehicles"
      end
    end
    end_time = Time.now
    total_time = end_time - start_time
    puts "It took #{total_time} seconds to import #{counter} vehicles"
    puts "There were #{invalids} invalid vehicles"
  end
end
