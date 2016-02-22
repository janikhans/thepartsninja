module ApplicationHelper

  def bool_to_checkmark(item)
    if item == true
      '<i class="fa fa-check"></i>'.html_safe
    end
  end
end
