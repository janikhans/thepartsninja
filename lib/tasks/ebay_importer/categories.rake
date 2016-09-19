require 'csv'

namespace :ebay_import do

  desc "Find categories from Ebay Parts CSV"
  task :categories, [:file_path] => [:environment] do |t, args|
    filepath = File.join Rails.root, args[:file_path]
    filename = File.basename args[:file_path], ".csv"
    counter = 0
    start_time = Time.now
    categories = []
    invalids = 0

    File.foreach(filepath) do |line|
      begin
        CSV.parse(line) do |row|
          breadcrumb = row[6]
          categories_list = breadcrumb.split(":")[2..-1]
          categories << categories_list
        end
      rescue CSV::MalformedCSVError => e
        invalids += 1
      end
      counter += 1
      if counter % 10000 == 0
        puts "Analyzed #{counter} parts"
      end
    end

    category_counts = categories.each_with_object(Hash.new(0)) { |category,counts| counts[category] += 1 }
      .sort_by {|key, value| value}.reverse.to_h

    export_path = "ebay_data/#{filename}_categories.csv"
    CSV.open(export_path, "w") do |csv|
      csv << ['Category Breadcrumb', 'Count']  #column head of csv file
      category_counts.each do |category|
        csv << [category[0].join(":"), category[1]] #fields name
      end
    end

    end_time = Time.now
    total_time = end_time - start_time
    puts "#{counter} part records were analyzed in #{total_time} seconds"
    puts "#{invalids} invalid part records were found"
    puts "The exported categories can be found in #{export_path}"
  end
end
