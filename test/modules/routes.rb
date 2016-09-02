# module Routes
#   ROUTES = Rails.application.routes.routes.map do |route|
#     # Turn the route path spec into a string:
#     # - Remove the "(.:format)" bit at the end
#     # - Use "1" for all params
#     path = route.path.spec.to_s.gsub(/\(\.:format\)/, "").gsub(/:[a-zA-Z_]+/, "1")
#     # Route verbs are stored as regular expressions; convert them to symbols
#     verb = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first.downcase.to_sym
#     # Return a hash with two keys: the route path and it's verb
#     { path: path, verb: verb }
#   end
# end
