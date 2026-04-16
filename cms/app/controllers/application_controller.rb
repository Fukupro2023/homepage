class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  http_basic_authenticate_with(
    name: ENV.fetch("BASIC_AUTH_USER") { Rails.env.local? ? "admin" : raise("BASIC_AUTH_USER must be set") },
    password: ENV.fetch("BASIC_AUTH_PASSWORD") { Rails.env.local? ? "password" : raise("BASIC_AUTH_PASSWORD must be set") },
    except: []
  )
end
