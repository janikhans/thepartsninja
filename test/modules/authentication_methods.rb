module AuthenticationMethods
  DSL_METHODS = [:sign_in, :sign_out]

  class ::Capybara::Session
    include Rails.application.routes.url_helpers
    include Test::Unit::Assertions

    def sign_in(user, options = {})
      visit new_user_session_path
      fill_in "user_login", with: user.email
      fill_in "user_password", with: options[:password] || "password"
      click_button "Log In"
      unless options[:expect] == :failure
        assert has_text? "Signed in successfully."
      end
    end

    def sign_out
      within ".navbar" do
        click_on "Sign Out"
      end
    end
  end

  module ::Capybara::DSL
    DSL_METHODS.each do |method|
      define_method method do |*args, &block|
        page.send(method, *args, &block)
      end
    end
  end
end
