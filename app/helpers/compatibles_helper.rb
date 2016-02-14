module CompatiblesHelper

  #Changes the link color if current_user has voted on this compatible
  def upvoted_compatible(compatible)
    if current_user
      'upvoted' if current_user.voted_up_on? compatible
    end
  end

  def downvoted_compatible(compatible)
    if current_user
      'downvoted' if current_user.voted_down_on? compatible
    end
  end

  #Changes color of the score based on its over score
  def compatible_score_color(compatible)
    if compatible.cached_votes_score > 0
      'class = green'
    elsif compatible.cached_votes_score < 0
      'class = red'
    else
      nil
    end
  end

  #Removes links if user isn't signed in. Otherwise we can get server hits when they're not neccessary
  def vote_actions(compatible)
    if current_user
      capture do
        concat link_to('', upvote_compatible_path(compatible.id), remote: true, id: "upvote_#{compatible.id}", class: "fa fa-chevron-up #{upvoted_compatible compatible} up")
        concat content_tag(:div, "#{compatible.cached_votes_score}", class: "#{compatible_score_color(compatible)}")
        concat link_to('', downvote_compatible_path(compatible.id), remote: true, id: "downvote_#{compatible.id}", class: "fa fa-chevron-down #{downvoted_compatible compatible} down")
      end
    else
      capture do
        concat content_tag(:i, "", class: "fa fa-chevron-up")
        concat content_tag(:div, "#{compatible.cached_votes_score}", class: "#{compatible_score_color(compatible)}")
        concat content_tag(:i, "", class: "fa fa-chevron-down")
      end
    end
  end

end
