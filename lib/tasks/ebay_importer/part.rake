require 'csv'

namespace :ebay_import do

  desc "Import parts from Ebay Parts CSV"
  task :parts, [:file_path] => [:environment] do |t, args|
    filename = File.join Rails.root, args[:file_path]
    counter = 0
    invalid_parts = []
    start_time = Time.now

    colors = ["Black","Red","Blue","White","Silver","Gold","Orange","Green","Yellow","Amber","Gray",
    "Black/Red","Red/Black","Pink","Matte Black","Black/Black","Flat Black","Black/White",
    "Dark Blue","Purple","Black/Blue","Silver/Black","Blue/Black","Black/Gold","Black/Carbon",
    "Black/Gray","Black/Orange","Black/Green"]

    finish = ["Chrome","Polished","Black Anodized","Brushed Aluminum","Blue Anodized",
    "Black Carbon Fiber","Clear","White Carbon Fiber","Natural","Gloss Black"]

    teeth = ["14T","13T","15T","48T","50T","45T","47T","42T","46T","44T","43T","51T","12T","52T",
    "16T","40T","41T","49T","38T","39T","17T","37T","66T","53T","36T","70T","11T","54T",
    "35T","18T","55T","34T","22T","56T","24T","33T","23T","65T","32T","21T","19T","10T",
    "25T","132T","30T","57T","135T","9T","133T","102T"]

    links = ["130 Links","120 Links","110 Links","150 Links","100 Links","114 Links","116 Links",
    "112 Links","104 Links","118 Links","106 Links","102 Links","108 Links","160 Links",
    "90 Links","96 Links","92 Links","88 Links","86 Links","84 Links","98 Links",
    "140 Links","132 Links","82 Links","122 Links","124 Links","94 Links","126 Links",
    "134 Links","76 Links","136 Links"]

    location = ["Front", "Rear", "Left", "Right", "Front/Rear", "Upper", "Lower"]
    size = ["Small", "Medium", "Large", "X-Large", "XX-Large"]

    bore = ["Standard Bore 54.00mm","Standard Bore 66.35mm","Standard Bore 76.96mm","Standard Bore 96.00mm",
    "Standard Bore 77.00mm","Standard Bore 53.95mm","Standard Bore 53.96mm","Standard Bore 72.00mm",
    "Standard Bore 95.96mm","Standard Bore 66.34mm","Standard Bore 66.40mm","Standard Bore 76.97mm",
    "Standard Bore 95.00mm","54.00mm Bore","Standard Bore 78.00mm","Standard Bore 81.00mm",
    "Standard Bore 53.94mm","Standard Bore 94.95mm","Standard Bore 76.95mm","Standard Bore 76.00mm",
    "Standard Bore 82.00mm","Standard Bore 66.00mm","Standard Bore 95.97mm","Standard Bore 94.96mm",
    "Standard Bore 80.00mm","Standard Bore 85.00mm","77.00mm Bore","Standard Bore 66.36mm",
    "Standard Bore 83.00mm","66.40mm Bore","Standard Bore 95.95mm","78mm Bore","Standard Bore 65.00mm",
    "Standard Bore 53.97mm","Standard Bore 95.98mm","68mm Bore","70mm Bore","Standard Bore 67.00mm",
    "Standard Bore 68.00mm","96.00mm Bore","Standard Bore 64.00mm","Standard Bore 100.00mm",
    "Standard Bore 76.98mm","77mm Bore","Standard Bore 73.00mm","76mm Bore",
    "79mm Bore","Standard Bore 47.00mm","Standard Bore 94.97mm","Standard Bore 46.95mm","81mm Bore",
    "Standard Bore 56.00mm","80.00mm Bore","96mm Bore","75mm Bore","68.00mm Bore",
    "Standard Bore 94.94mm","Standard Bore 88.00mm","98mm Bore","97.00mm Bore","95.00mm Bore",
    "Standard Bore 66.50mm","80mm Bore","Standard Bore 70.00mm","72mm Bore","85.00mm Bore",
    "Standard Bore 97.00mm","97mm Bore","74mm Bore","Standard Bore 74.00mm","Standard Bore 77.97mm",
    "Standard Bore 77.96mm","82mm Bore","Standard Bore 77.95mm","Standard Bore 63.95mm","83mm Bore",
    "76.00mm Bore","99mm Bore","Standard Bore 96.95mm","Standard Bore 84.00mm","102.00mm Bore",
    "95mm Bore","88.00mm Bore","Standard Bore 96.96mm","81.00mm Bore","78.00mm Bore",
    "Standard Bore 47.45mm","Standard Bore 67.50mm","66.00mm Bore","Standard Bore 102.00mm","85mm Bore",
    "Standard Bore 95.50mm","56.00mm Bore","100mm Bore","84mm Bore","Standard Bore 71.95mm",
    "58.00mm Bore","Standard Bore 71.00mm","Standard Bore 67.75mm","Standard Bore 48.00mm",
    "Standard Bore 89.00mm","72.00mm Bore","100.00mm Bore","Standard Bore 47.95mm",
    "69mm Bore","Standard Bore 77.25mm","Standard Bore 66.37mm","67.00mm Bore","Standard Bore 47.50mm",
    "Standard Bore 96.93mm","90.00mm Bore","Standard Bore 77.98mm",
    "Standard Bore 76.76mm","Standard Bore 95.47mm","68.50mm Bore","83.00mm Bore","Standard Bore 101.97mm",
    "Standard Bore 69.50mm","Standard Bore 89.96mm","98.00mm Bore","Standard Bore 95.46mm",
    "Standard Bore 76.78mm","74.00mm Bore","101mm Bore","Standard Bore 101.96mm","48.00mm Bore",
    "Standard Bore 44.97mm","Standard Bore 63.94mm","Standard Bore 74.50mm","Standard Bore 76.77mm",
    "94mm Bore","84.00mm Bore","Standard Bore 70.50mm"]

    overbore = ["2.00mm Oversize to 56.00mm","1.00mm Oversize to 55.00mm","0.50mm Oversize to 54.50mm",
    "0.50mm Oversize to 66.50mm","1.00mm Oversize to 67.00mm","2.00mm Oversize to 68.00mm",
    "1.00mm Oversize to 73.00mm","0.50mm Oversize to 72.50mm","2.10mm Oversize to 68.50mm",
    "1.00mm Oversize to 77.00mm","0.50mm Oversize to 76.50mm","1.00mm Oversize to 68.00mm",
    "1.50mm Oversize to 67.50mm","1.10mm Oversize to 67.50mm","1.00mm Oversize to 48.00mm",
    "1.00mm Oversize to 71.00mm","1.50mm Oversize to 73.50mm","0.50mm Oversize to 64.50mm",
    "1.00mm Oversize to 79.00mm","1.00mm Oversize to 57.00mm","0.50mm Oversize to 47.50mm",
    "1.00mm Oversize to 75.00mm","0.50mm Oversize to 80.50mm Bore",".01mm Oversize to 76.97mm",
    "0.60mm Oversize to 67.00mm","1.00mm Oversize to 82.00mm Bore","2.00mm Oversize to 66.00mm",
    "0.50mm Oversize to 81.50mm Bore","1.00mm Oversize to 65.00mm","1.00mm Oversize to 86.00mm",
    ".02mm Oversize to 66.36mm",".01mm Oversize to 66.35mm","1.00mm Oversize to 81.00mm Bore",
    "0.50mm Oversize to 56.50mm","0.50mm Oversize to 48.00mm","2.00mm Oversize to 72.00mm",
    "1.00mm Oversize to 49.00mm","1.00mm Oversize to 48.50mm","0.50mm Oversize to 83.50mm",
    "0.50mm Oversize to 81.50mm","0.50mm Oversize to 65.50mm",".01mm Oversize to 53.96mm",
    "2.00mm Oversize to 49.50mm","1.00mm Oversize to 82.00mm",".02mm Oversize to 76.98mm",
    "0.50mm Oversize to 70.00mm","0.50mm Oversize to 85.50mm","2.00mm Oversize to 79.00mm",
    "0.50mm Oversize to 73.50mm","1.00mm Oversize to 84.00mm","2.00mm Oversize to 69.00mm",
    "1.00mm Oversize to 101.00mm",".02mm Oversize to 53.97mm","1.00mm Oversize to 81.00mm",
    "1.00mm Oversize to 74.00mm","1.50mm Oversize to 55.50mm","0.25mm Oversize to 81.25mm Bore",
    "0.50mm Oversize to 70.50mm","1.00mm Oversize to 83.00mm","0.50mm Oversize to 74.50mm",
    "1.00mm Oversize to 66.00mm","1.00mm Oversize to 103.00mm","2.00mm Oversize to 50.00mm",
    "2.00mm Oversize to 49.00mm","0.25mm Oversize to 66.25mm","1.50mm Oversize to 65.50mm",
    "0.50mm Oversize to 48.50mm","1.50mm Oversize to 77.50mm","0.75mm Oversize to 81.75mm Bore",
    "2.00mm Oversize to 97.00mm",".02mm Oversize to 95.98mm","1.50mm Oversize to 49.00mm",
    ".02mm Oversize to 94.98mm","0.50mm Oversize to 68.50mm","0.50mm Oversize to 82.50mm",
    "0.50mm Oversize to 67.50mm","1.00mm Oversize to 69.00mm",".01mm Oversize to 95.97mm",
    "1.00mm Oversize to 87.00mm","1.00mm Oversize to 77.00mm Bore",
    "0.50mm Oversize to 82.50mm Bore","2.00mm Oversize to 91.00mm","0.50mm Oversize to 80.50mm",
    ".01mm Oversize to 94.97mm","1.25mm Oversize to 67.25mm","2.00mm Oversize to 70.00mm",
    "0.50mm Oversize to 76.50mm Bore","1.00mm Oversize to 90.00mm",
    "0.25mm Oversize to 80.25mm Bore","2.00mm Oversize to 87.00mm",".01mm Oversize to 94.96mm",
    "1.00mm Oversize to 85.00mm Bore","0.50mm Oversize to 89.50mm","0.75mm Oversize to 66.75mm"]

    tire_size = ["120/70ZR-17","180/55ZR-17","190/55ZR-17","190/50ZR-17","160/60ZR-17","120/60ZR-17",
    "150/70R-17","110/80R-19","110/80-19","170/60ZR-17","120/70ZR-18","110/70ZR-17",
    "160/60ZR-18","200/50ZR-17","160/60R-17","150/60ZR-17","110/80ZR-18","140/80R-17",
    "170/60R-17","150/70ZR-17","120/70R-17","130/70R-18","200/55ZR-17","180/70R-16",
    "130/80R-17","150/80R-16","120/70R-19","120/70R-15","130/70R-17","130/70ZR-16",
    "180/60ZR-17","120/60R-17","150/70R-18","170/60-17","110/70R-17","150/80-16 WW",
    "200/55R-17","180/55VR-17","240/40ZR-18","160/70ZR-17","100/90-19","110/90-19",
    "80/100-21","90/90-21","110/100-18","130/90-16","70/100-17","120/90-18","90/100-14",
    "100/100-18","150/80-16","70/100-19","80/100-12","120/100-18","120/80-19",
    "140/90-15","100/90-18","120/70-12","120/80-18","110/80-18","140/90-16","150/90-15",
    "130/90-17","80/90-21","110/70-17","140/80-17"]

    gallons = ["3.2Gal.","4.0Gal.","3.1Gal.","3.3 Gal.","3.4Gal.","3.0Gal.","3.6Gal.","3.2 Gal.",
    "2.7Gal.","3.4 Gal.","3.7Gal.","2.9Gal.","5.3 Gal.","3.1 Gal.","3.0 Gal.",
    "5.8 Gal.","3.5 Gal.","4.9Gal.","4.1 Gal.","2.6 Gal.","2.3 Gal.","4.0 Gal.",
    "2.5Gal.","4.2 Gal.","2.8Gal.","3.9 Gal.","2.9 Gal.","2.2 Gal.","2.7 Gal.","2.6Gal.",
    "2.8 Gal.","5.6Gal."]

    File.foreach(filename) do |line|
      begin
        CSV.parse(line) do |row|
          category_breadcrumb = row[6].split(":")
          parent_category = category_breadcrumb[2]
          category = category_breadcrumb[3]
          subcategory = category_breadcrumb[4]
          note = row[4].split(",")[1]
          attribute_list = note
          part_attributions = []

          if attribute_list
            attribute_list.strip!
            attributes = attribute_list.split(" - ")

            attributes.each do |a|
              if colors.include?(a)
                attribution = {parent_attribute: "Color", attribute: a}
              elsif finish.include?(a)
                attribution = {parent_attribute: "Finish", attribute: a}
              elsif teeth.include?(a)
                attribution = {parent_attribute: "Teeth", attribute: a}
              elsif links.include?(a)
                attribution = {parent_attribute: "Links", attribute: a}
              elsif location.include?(a)
                attribution = {parent_attribute: "Location", attribute: a}
              elsif size.include?(a)
                attribution = {parent_attribute: "Size", attribute: a}
              elsif bore.include?(a)
                attribution = {parent_attribute: "Bore", attribute: a}
              elsif overbore.include?(a)
                attribution = {parent_attribute: "Overbore", attribute: a}
              elsif tire_size.include?(a)
                attribution = {parent_attribute: "Tire Size", attribute: a}
              elsif gallons.include?(a)
                attribution = {parent_attribute: "Gallons", attribute: a}
              else
                next
              end
              part_attributions << attribution
            end
          end

          part = EbayPartImportForm.new(brand: row[1], product_name: row[2],
                              part_number: row[3], epid: row[0],
                              parent_category: parent_category, category: category,
                              subcategory: subcategory, note: note, attributes: part_attributions)
          if part.valid?
            if part.save
              true
            else
              invalid_parts << [line, part.errors.full_messages]
            end
          else
            invalid_parts << [line, part.errors.full_messages]
          end
        end
      rescue CSV::MalformedCSVError => e
        invalid_parts << line
      end
      counter += 1
      if counter % 10000 == 0
        puts "Imported #{counter} parts"
      end
    end

    CSV.open("ebay_data/invalid_malformed_parts.csv", "w") do |csv|
      csv << ["Part"]
      invalid_parts.each do |invalid|
        csv << [invalid] #fields name
      end
    end

    end_time = Time.now
    total_time = end_time - start_time
    puts "It took #{total_time} seconds to import #{counter} parts"
    puts "There were #{invalid_parts.count} invalid parts"
    puts "Invalid parts can be found in ebay_data/invalid_malformed_parts.csv"
  end
end
