class SearchController < ApplicationController

  def index
      ## Lets takes those params from the view....
      make = params[:search][:make].strip
      year = params[:search][:year]
      model = params[:search][:model].strip
      @part = params[:search][:part_name].strip

      #Finding the brand first and then the vehicle
      brand = Brand.where('lower(name) = ?', make.downcase).first
      @vehicle = Vehicle.where("lower(model) like ? AND year = ? AND brand_id = ?", model.downcase, year, brand).first

      # Doing this in case a vehicle isn't found in the database
      if @vehicle
        #Setting up the various variables that we'll be using.  
        oem_parts = @vehicle.oem_parts.all
        compatible_compatibles = @vehicle.compats
        @oem_search_results = []
        @compatible_search_results = []
        compatible_parts = []
        vehicles = []
        fitments = []
        potential_fitments = []
        compatible_fitments = []
        part_compatibles = []
        potential_parts = []

        #These are just the OEM Parts that belong to the vehicle and then searched to see if the name includes the Part search param
        oem_parts.each do |p| 
          if  p.product.name.downcase.include? @part.downcase
            @oem_search_results << p
          end
        end

        #These is going search through all the compatibles that the belong to the vehicle and see if the part has the Part search params. This also adds the compatible_fitment part that we'll need for Potentials later
        compatible_compatibles.each do |p| 
          if  p.fitment.part.product.name.downcase.include? @part.downcase
            @compatible_search_results << p
            compatible_parts << p.compatible_fitment.part
          end
        end
        # binding.pry

        ## THIS FINDS POTENTIAL COMPATIBLE FITMENTS -> PART AND VEHICLE COMBINATION

        #Here we are finding all the other fitments that a part has. These should fit because they are technically the same part and were designed for multiple vehicles. The database doesn't have a fitment for these yet. 
        @oem_search_results.each do |p|
          fitments << p.fitments
        end

        #
        compatible_parts.each do |c|
          part_compatibles << c.compats
          part_compatibles.flatten!
          part_compatibles.each do |p|
            compatible_fitments << p.compatible_fitment
          end
        end
        compatible_fitments.flatten!

        compatible_fitments.each do |c|
          potential_parts << c.part
        end
        potential_parts.flatten!

        potential_parts.each do |p|
          potential_fitments << p.fitments
        end
        potential_fitments.flatten!


        comparable_fitments = []
        @compatible_search_results.each do |c|
          comparable_fitments << c.compatible_fitment
        end
        comparable_fitments.flatten!



        fitments.flatten!

        fitments.reject! { |f| f.vehicle == @vehicle }
        potential_fitments.reject! { |p| comparable_fitments.include?(p) }
        potential_fitments.reject! { |f| f.vehicle == @vehicle }

        @potential_fitments = fitments | potential_fitments

      else
        @nothing_exists = true
      end
    
  end

end
