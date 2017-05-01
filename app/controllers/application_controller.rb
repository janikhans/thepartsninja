class ApplicationController < ActionController::Base
  # before_action :set_raven_context
  before_action :prepare_meta_tags, if: 'request.get?'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_back_or_default(default = root_path, options = {})
    redirect_to (request.referer.present? ? :back : default), options
  end

  def coming_soon
    redirect_to coming_soon_path unless current_user
  end

  def after_sign_in_path_for(*)
    account_root_path
  end

  def prepare_meta_tags(options={})
    site_name   = 'The Parts Ninja'
    title       = 'The Community Motorsports Parts Project'
    description = 'By utilizing the Parts Compatibility Web formed with
      exisiting data and user contributions, The Parts Ninja helps you spend
      less time searching and more time riding.'
    image       = options[:image] || 'http://www.thepartsninja.com/assets/parts_ninja_dark_logo-4e0681bbd6019db9fbbf9122ee2d97adc45ff0118b9087ad47cce11fa8588452.png'
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    %w[motorsports parts dirtbike compatibilities motorcycle repair fitments atv utv ],
      twitter: {
        site_name: site_name,
        site: '@thepartsninja',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:login, :username, :email, :password, :remember_me)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, :email, :password, :password_confirmation, :remember_me, :terms_of_service)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:username, :email, :password, :password_confirmation, :current_password)
    end
    devise_parameter_sanitizer.permit(:accept_invitation) do |user_params|
      user_params.permit(:username, :password, :password_confirmation, :invitation_token)
    end
  end

  private

  # def set_raven_context
  #   Raven.user_context(id: current_user.id) if current_user
  # end
end
