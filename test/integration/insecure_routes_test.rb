# require 'test_helper'
#
# class InsecureRoutesTest < ActionDispatch::IntegrationTest
#   include Routes
#
#   INSECURE_PREFIXES = %w{ /contact /about /sign_up /password_reset
#     /login /users/sign_in
#   }
#
#   INSECURE_PATHS = %w{ / }
#
#   test "no insecure routes exist" do
#     # Admin routes are tested elsewhere
#     routes = ROUTES.reject do |route|
#       route[:path].starts_with?("/admin") ||
#         INSECURE_PREFIXES.any? { |prefix| route[:path].starts_with? prefix } ||
#         INSECURE_PATHS.any? { |prefix| route[:path] == prefix }
#     end
#     refute routes.empty?
#
#     insecure_routes = []
#
#     routes.each do |route|
#       begin
#         reset!
#         # Use the route's verb to access the route's path
#         request_via_redirect(route[:verb], route[:path])
#         # If we aren't redirected to the login, the route is insecure
#         insecure_routes << "#{route[:verb]} #{route[:path]}" unless path == sign_in_path || path == ship_it_sign_in_path
#       rescue ActiveRecord::RecordNotFound
#         # Since we are blindly submitting "1" for all route params, this error can pop up.
#         # If it does, it means that the request got past the `before_action` and to the
#         # code in the controller where it attempts to locate the record in the database.
#         # That means this is an insecure route.
#         insecure_routes << "#{route[:verb]} #{route[:path]}"
#       rescue AbstractController::ActionNotFound
#         # This error means the route doesn't connect to a controller action. This is a
#         # problem if it happens, but this is a separate concern and should be tested
#         # elsewhere.
#       rescue
#         insecure_routes << "#{route[:verb]} #{route[:path]}"
#       end
#     end
#
#     # Fail if we have insecure routes.
#     assert insecure_routes.empty?,
#       "The following routes are not secure: \n\t#{insecure_routes.uniq.join("\n\t")}"
#   end
# end
