class SearchController < ApplicationController

  def index
      make = params[:search][:make].strip
      year = params[:search][:year]
      model = params[:search][:model].strip
      @part = params[:search][:part_name].strip

      brand = Brand.where('lower(name) = ?', make.downcase).first
      @vehicle = Vehicle.where("model like ? AND year = ? AND brand_id = ?", model, year, brand).first

      if @vehicle
        oem_parts = @vehicle.oem_parts.all
        compatible_parts = @vehicle.compats
        @oem_search_results = []
        @compatible_search_results = []
        @backwards_compatible_search_results = []

        oem_parts.each do |p| 
          if  p.product.name.downcase.include? @part.downcase
            @oem_search_results << p
          end
        end

        compatible_parts.each do |p| 
          if  p.fitment.part.product.name.downcase.include? @part.downcase
            @compatible_search_results << p
          end
        end
      else
        @nothing_exists = true
      end
    
  end

end
