class SearchesController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def results

    @user_searches = current_user.searches.where(vehicle_id: !nil).reverse[0..3] if user_signed_in? # Not giving me the most recent ones. Needs to search and limit at the same time.

    ## Lets takes those params from the url....
    @make = params[:search][:brand].strip
    @year = params[:search][:year]
    @model = params[:search][:model].strip
    # @part = params[:search][:part_name].strip
    @part = params[:search][:part]

    if ((@make.empty? || @year.empty? || @model.empty? || @part.empty? ) && !user_signed_in?) # So that only searches with all inputs get saved. - Very dirty hack imo.
      redirect_to coming_soon_path
    else
      @existing_part = Category.where('lower(name) = ?', @part.downcase).first

      #Finding the brand first and then the vehicle
      brand = Brand.where('lower(name) = ?', @make.downcase).first
      year = VehicleYear.where('year = ?', @year).first
      @vehicle = Vehicle.where("lower(model) like ? AND vehicle_year_id = ? AND brand_id = ?", @model.downcase, year, brand).first

      @new_search = Search.new

      if @vehicle
        @new_search.vehicle = @vehicle
      else
        if brand
          @new_search.brand = brand.name
        else
          @new_search.brand = @make
        end
        @new_search.model = @model
        @new_search.year = @year
      end

      if @existing_part
        @new_search.part = @existing_part.name
      else
        @new_search.part = @part
      end

      if user_signed_in?
        @new_search.user = current_user

        # Doing this in case a vehicle isn't found in the database
        if @vehicle
          #Setting up the various variables that we'll be using.
          @oem_search_results = []
          @compatible_search_results = []
          oem_parts = @vehicle.oem_parts
          compatible_parts = []
          potential_parts = []

          oem_parts.each do |p|
            # if p.product.category.name.downcase.include? @part.downcase
            if p.product.category === @existing_part
              @oem_search_results << p
            end
          end

          #Sloppy hack to fix errors. - Fix this.
          if @oem_search_results.any?

            @oem_search_results.each do |p|
              compatible_parts << p.compatibles
              potential_parts << p.find_potentials
            end
            @potential_parts = potential_parts.flatten!
            compatible_parts.flatten!
            @compatible_search_results = compatible_parts.sort_by {|c| c.cached_votes_score }.reverse

            #Setting search analytics to track results
            @new_search.compatibles = @compatible_search_results.count
            @new_search.potentials = @potential_parts.count
          else
            @vehicle = nil
          end
        end
        @new_search.save
      else
        @new_search.save

        #This should redirect to a lead generation page
        redirect_to coming_soon_path
      end
    end
  end

end
