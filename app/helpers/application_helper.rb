module ApplicationHelper

  def bool_to_checkmark(item)
    if item == true
      '<i class="fa fa-check green"></i>'.html_safe
    end
  end


  def potential_score(potential)
    capture do
      if potential >= 0.5
        concat '<i class="fa fa-signal green"></i>'.html_safe
      elsif (0.1 < potential && potential < 0.5)
        concat '<i class="fa fa-signal yellow"></i>'.html_safe
      else
        concat '<i class="fa fa-signal"></i>'.html_safe
      end
      concat potential
    end
  end
end
