#Currently isn't working correctly.
class CustomFailure < Devise::FailureApp
  def redirect_url
    new_user_session_path
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect_to new_user_session_path
    end
  end
end
