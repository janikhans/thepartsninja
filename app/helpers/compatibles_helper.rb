module CompatiblesHelper
  def upvoted_compatible(compatible)
    if current_user
      return 'upvoted' if current_user.voted_up_on? compatible
    end
  end

  def downvoted_compatible(compatible)
    if current_user
      return 'downvoted' if current_user.voted_down_on? compatible
    end
  end
end
