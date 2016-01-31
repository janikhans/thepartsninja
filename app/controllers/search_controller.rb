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
        vehicle_fitments = @vehicle.fitments
        compatible_compatibles = @vehicle.compats
        @oem_search_results = []
        @compatible_search_results = []
        potential_fitments = []
        oem_fitments = []

        vehicle_fitments.each do |p|
          if p.part.product.name.downcase.include? @part.downcase
            @oem_search_results << p.part
            oem_fitments << p
          end
        end

        oem_fitments.each do |p|
          potential_fitments << p.find_potentials
        end

        #These is going search through all the compatibles that the belong to the vehicle and see if the part has the Part search params.
        compatible_compatibles.each do |p| 
          if  p.fitment.part.product.name.downcase.include? @part.downcase
            @compatible_search_results << p
          end
        end

        potential_fitments.flatten!
        @potential_fitments = potential_fitments
      else
        @nothing_exists = true
      end
    
  end

end
