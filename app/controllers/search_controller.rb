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
        @oem_search_results = []
        @compatible_search_results = []
        oem_parts = @vehicle.oem_parts
        compatible_parts = []
        potential_parts = []

        oem_parts.each do |p|
          if p.product.name.downcase.include? @part.downcase
            @oem_search_results << p
          end
        end

        @oem_search_results.each do |p|
          compatible_parts << p.compats
          potential_parts << p.find_potentials
        end

        @potential_parts = potential_parts.flatten!
        compatible_parts.flatten!
        @compatible_search_results = compatible_parts.sort_by {|c| c.cached_votes_score }.reverse

      else
        @nothing_exists = true
      end
    
  end

end
