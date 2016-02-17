module ProfilesHelper

  def user_bio(user)
    if user.profile.bio
      user.profile.bio
    else
      "This user must be an enigma - they have no bio!"
    end
  end

  def user_location(user)
    if user.profile.location
      user.profile.location
    end
  end

end
