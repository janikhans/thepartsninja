class SearchController < ApplicationController

  def index

    if params[:q][:year_matches].blank? || params[:q][:brand_name_matches].blank? || params[:q][:model_matches].blank? || params[:part][:part_name].blank?
      @new_search = true
    else
      @q = Vehicle.ransack(params[:q])
      @vehicle = @q.result.includes(:brand).first
      @part = params[:part][:part_name]

      oem_parts = @vehicle.oem_parts.all
      compatible_parts = @vehicle.compats
      @oem_search_results = []
      @compatible_search_results = []
      @backwards_compatible_search_results = []

      oem_parts.each do |p| 
        if  p.product.name.downcase.include? @part.downcase.strip
          @oem_search_results << p
        end
      end

      compatible_parts.each do |p| 
        if  p.fitment.part.product.name.downcase.include? @part.downcase.strip
          @compatible_search_results << p
        end
      end

    end
    
  end

end
