class SearchesController < ApplicationController
  #before_action :authenticate_user!, only: [:results, :index]

  def results

    @user_searches = current_user.searches.where(vehicle_id: !nil).reverse[0..3] if user_signed_in? # Not giving me the most recent ones. Needs to search and limit at the same time.

    @categories = Category.all
    ## Lets takes those params from the url....
    make = params[:search][:brand].strip
    year = params[:search][:year]
    model = params[:search][:model].strip
    # @part = params[:search][:part_name].strip
    part = params[:search][:part]
    @part = Category.where('lower(name) = ?', part.downcase).first

    #Finding the brand first and then the vehicle
    brand = Brand.where('lower(name) = ?', make.downcase).first
    @vehicle = Vehicle.where("lower(model) like ? AND year = ? AND brand_id = ?", model.downcase, year, brand).first

    @new_search = Search.new

    if @vehicle
      @new_search.vehicle = @vehicle
    else
      if brand
        @new_search.brand = brand
      else
        @new_search.brand = make
      end
      @new_search.model = model
      @new_search.year = year
    end

    @new_search.part = part

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
          if p.product.category === @part
            @oem_search_results << p
          end
        end

        #Sloppy hack to fix errors. - Fix this.
        if @oem_search_results.any?

          @oem_search_results.each do |p|
            compatible_parts << p.compats
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
      redirect_to root_path, alert: "You don't have access to that"
    end
  end

end
