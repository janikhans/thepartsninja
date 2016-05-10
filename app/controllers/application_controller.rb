class ApplicationController < ActionController::Base
  before_action :prepare_meta_tags, if: "request.get?"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def redirect_back_or_default(default = root_path, options = {})
    redirect_to (request.referer.present? ? :back : default), options
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def prepare_meta_tags(options={})
    site_name   = "The Parts Ninja"
    title       = "The Ultimate Motorsports Parts App"
    description = "The Parts Ninja is the master at searching for parts. He'll cross reference thousands of parts to find you every compatibility possible. Spend less time searching and more time riding."
    image       = options[:image] || "http://www.theparts.ninja/assets/ThePartsNinjaDefault-821b4f404fcff3d74ebc59e30987846ce15385b2784b620a12bf40fbbd4e0d4b.jpg"
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
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:username, :email, :password, :password_confirmation, :current_password)}
    devise_parameter_sanitizer.for(:accept_invitation) {|u| u.permit(:username, :password, :password_confirmation, :invitation_token)}
  end

end
