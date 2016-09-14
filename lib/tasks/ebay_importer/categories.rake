require 'csv'

namespace :ebay_import do

  desc "Find categories from Ebay Parts CSV"
  task categories: :environment do
    filename = File.join Rails.root, "ebay_parts_data.csv"
    counter = 0
    start_time = Time.now
    categories = []
    invalids = []

    File.foreach(filename) do |line|
      begin
        CSV.parse(line) do |row|
          breadcrumb = row[6]
          categories_list = breadcrumb.split(":")[2..-1]
          categories << categories_list
        end
      rescue CSV::MalformedCSVError => e
        invalids << line
      end
      counter += 1
      if counter % 10000 == 0
        puts "Analyzed #{counter} parts"
      end
    end

    category_counts = categories.each_with_object(Hash.new(0)) { |category,counts| counts[category] += 1 }
      .sort_by {|key, value| value}.reverse.to_h

    CSV.open("category_export.csv", "w") do |csv|
      csv << ['Category Breadcrumb', 'Count']  #column head of csv file
      category_counts.each do |category|
      csv << [category[0].join(":"), category[1]] #fields name
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
    puts "#{category_counts.count} unqiue categories were found"
    puts "#{invalids.count} invalid part records were found"
    puts "The exported categories can be found in category_export.csv"
    puts "The invalid part records can be found in invalid_malformed_parts.csv"
  end
end
