require 'csv'

namespace :ebay_importer do

  desc "Find attributes Ebay Parts CSV"
  task :attributes, [:file_path] => [:environment] do |t, args|
    filepath = File.join Rails.root, args[:file_path]
    filename = File.basename args[:file_path], ".csv"
    counter = 0
    start_time = Time.now
    attributes = []
    invalids = 0

    File.foreach(filepath) do |line|
      begin
        CSV.parse(line) do |row|
          reserved_title = row[4]
          part_attribute_list = reserved_title.split(",")[1]
          if part_attribute_list
            part_attribute_list.strip!
            part_attributes = part_attribute_list.split(" - ")
            attributes << part_attributes
          end
        end
      rescue CSV::MalformedCSVError => e
        invalids += 1
      end
      counter += 1
      if counter % 10000 == 0
        puts "Analyzed #{counter} parts"
      end
    end

    attribute_counts = attributes.flatten.each_with_object(Hash.new(0)) { |attribute,counts| counts[attribute] += 1 }
                                 .sort_by {|_key, value| value}.reverse.to_h

    export_path = "ebay_data/#{filename}_attributes.csv"
    CSV.open(export_path, "w") do |csv|
      csv << ['Attribute Name', 'Count']  #column head of csv file
      attribute_counts.each do |attribute|
      csv << [attribute[0], attribute[1]] #fields name
      end
    end

    end_time = Time.now
    total_time = end_time - start_time
    puts "#{counter} part records were analyzed in #{total_time} seconds"
    puts "#{attribute_counts.count} unqiue attributes were found"
    puts "#{invalids} invalid part records were found"
    puts "The exported attributes can be found in #{export_path}"
  end
end
