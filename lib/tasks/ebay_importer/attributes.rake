require 'csv'

namespace :ebay_import do

  desc "Find attributes Ebay Parts CSV"
  task attributes: :environment do
    filename = File.join Rails.root, "ebay_parts_data.csv"
    # filename = "ebay_parts_test.csv"
    # file_path = Rails.root, "ebay_parts_data.csv"
    counter = 0
    start_time = Time.now
    attributes = []
    invalids = []

    File.foreach(filename) do |line|
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
        puts e.message
        invalids << line
      end
      counter += 1
      if counter % 10000 == 0
        puts "Analyzed #{counter} parts"
      end
    end

    attribute_counts = attributes.flatten.each_with_object(Hash.new(0)) { |attribute,counts| counts[attribute] += 1 }
                                 .sort_by {|_key, value| value}.reverse.to_h

    CSV.open("attribute_export.csv", "w") do |csv|
      csv << ['Attribute Name', 'Count']  #column head of csv file
      attribute_counts.each do |attribute|
      csv << [attribute[0], attribute[1]] #fields name
      end
    end

    # CSV.open("invalid_malformed_parts.csv", "w") do |csv|
    #   csv << ['Part Epid']  #column head of csv file
    #   invalids.each do |invalid|
    #     binding.pry
    #     csv << invalid #fields name
    #   end
    # end

    end_time = Time.now
    total_time = end_time - start_time
    puts "#{counter} part records were analyzed in #{total_time} seconds"
    puts "#{attribute_counts.count} unqiue attributes were found"
    puts "#{invalids.count} invalid part records were found"
    puts "The exported attributes can be found in attribute_export.csv"
    puts "The invalid parts can be found in invalid_malformed_parts.csv"
  end
end
