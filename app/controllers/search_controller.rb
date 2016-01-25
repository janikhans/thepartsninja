class SearchController < ApplicationController

  def index
      make = params[:search][:make].strip
      year = params[:search][:year]
      model = params[:search][:model].strip
      @part = params[:search][:part_name].strip

      brand = Brand.where('lower(name) = ?', make.downcase).first
      @vehicle = Vehicle.where("lower(model) like ? AND year = ? AND brand_id = ?", model.downcase, year, brand).first

      if @vehicle
        oem_parts = @vehicle.oem_parts.all
        compatible_compatibles = @vehicle.compats
        @oem_search_results = []
        @compatible_search_results = []

        compatible_fitments = []

        oem_parts.each do |p| 
          if  p.product.name.downcase.include? @part.downcase
            @oem_search_results << p
          end
        end

        compatible_compatibles.each do |p| 
          if  p.fitment.part.product.name.downcase.include? @part.downcase
            @compatible_search_results << p
            compatible_fitments << p.fitment
          end
        end
        

        ## THIS FINDS POTENTIAL COMPATIBLE FITMENTS -> PART AND VEHICLE COMBINATION
        vehicles = []
        fitments = []

        potential_fitments = []
        potential_vehicles = []

        @oem_search_results.each do |p|
          vehicles << p.oem_vehicles
          vehicles.flatten!
          vehicles.each do |v|
            fitments << v.fitments.where(part_id: p.id)
            fitments.flatten!
          end
        end

        compatible_fitments.each do |c|
          c.compats.each do |v|
            potential_fitments << v.compatible_fitment
          end
        end

        # potential_parts.each do |p|
        #   potential_vehicles << p.compats
        #   potential_vehicles.flatten!
        #   potential_vehicles.each do |v|
        #     potential_fitments << v.fitments.where(part_id: p.id)
        #     potential_fitments.flatten!
        #   end
        # end

        fitments.reject! { |f| f.vehicle == @vehicle }

        @potential_oem_fitments = fitments | potential_fitments

        # @compatible_search_results.reject! { |f| f.fitment.vehicle == @vehicle }

      else
        @nothing_exists = true
      end
    
  end

end
