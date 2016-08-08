module DiscoveriesHelper

  def vehicle_list(part)
    vehicles = part.oem_vehicles
    output = ''
    vehicles.each do |v|
      line = v.year.to_s + " " + v.brand.name + " " + v.model.name + '<br>'
      output += line
    end
    return output
  end

  def backwards(compatible)
    if compatible.backwards
      '<i class="fa fa-exchange fa-2x green"></i>'.html_safe
    else
      '<i class="fa fa-arrow-right fa-2x green"></i>'.html_safe
    end
  end

end
