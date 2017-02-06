module SearchesHelper
  def friendly_years_for(vehicles)
    output = ""
    previous_year = nil
    skip_year = false
    vehicles.each_with_index do |vehicle,index|
      if vehicles.size - 1 == index
        if previous_year == nil
          output += vehicle.year.to_s
        elsif vehicle.year.to_i == previous_year + 1
          output += "-" + vehicle.year.to_s
        else
          output += ", " + vehicle.year.to_s
        end
      elsif previous_year == nil
        output += vehicle.year.to_s
      elsif vehicle.year.to_i == previous_year + 1
        # We do nothing!
      else
        output += "-" + previous_year.to_s + ", " + vehicle.year.to_s
        skip_year = true
      end
      previous_year = vehicle.year.to_i
    end
    content_tag :span, output
    # add ? popover w/ explanation why there is a gap if skip_year == true
  end
end
