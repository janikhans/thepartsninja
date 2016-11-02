module ApplicationHelper

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

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

  def icon(name, options = {})
    icon_class = "fa fa-#{name.to_s.dasherize}"
    icon_class += " #{options[:class]}" if options.has_key?(:class)
    content_tag :i, nil, class: icon_class
  end

end
