module CompatibilitiesHelper
  # Changes the link color if current_user has voted on this compatibility
  def upvoted_compatibility(compatibility)
    if current_user
      'upvoted' if current_user.voted_up_on? compatibility
    end
  end

  def downvoted_compatibility(compatibility)
    if current_user
      'downvoted' if current_user.voted_down_on? compatibility
    end
  end

  # Changes color of the score based on its over score
  def compatibility_score_color(score)
    if score > 0.75
      'green'
    elsif score > 0.25
      'yellow'
    else
      'white'
    end
  end

  # Removes links if user isn't signed in. Otherwise we can get server hits when they're not neccessary
  def vote_actions(compatibility)
    if current_user
      capture do
        concat link_to('', upvote_compatibility_path(compatibility.id), remote: true, id: "upvote_#{compatibility.id}", class: "fa fa-chevron-up #{upvoted_compatibility compatibility} up")
        concat content_tag(:div, "#{compatibility.cached_votes_score}", id: "compat_#{compatibility.id}_score", class: "#{compatibility_score_color(compatibility)}", value:"#{compatibility.cached_votes_score}")
        concat link_to('', downvote_compatibility_path(compatibility.id), remote: true, id: "downvote_#{compatibility.id}", class: "fa fa-chevron-down #{downvoted_compatibility compatibility} down")
      end
    else
      capture do
        concat content_tag(:i, "", class: "fa fa-chevron-up")
        concat content_tag(:div, "#{compatibility.cached_votes_score}", class: "#{compatibility_score_color(compatibility)}")
        concat content_tag(:i, "", class: "fa fa-chevron-down")
      end
    end
  end

  #Outputs the title for the compatibility
  def part_vehicle_fitments(part)
    capture do
      if part.fitments.count > 1
        concat "Multiple Vehicles"
      elsif part.fitments.count === 1
        vehicle = part.oem_vehicles.first
        concat vehicle.year.to_s + " " + vehicle.brand.name + " " + vehicle.model.name + " "
      else
        nil
      end
      concat "&nbsp;- ".html_safe + part.product.brand.name + " "
      concat part.product.name + " "
    end
  end
end
