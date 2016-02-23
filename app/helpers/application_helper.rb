module ApplicationHelper

  def bool_to_checkmark(item)
    if item == true
      '<i class="fa fa-check green"></i>'.html_safe
    end
  end
end
