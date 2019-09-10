# frozen_string_literal: true

Bugno.configure do |config|
  # Specify api key to send exception to Bugno
  config.api_key = ENV['BUGNO_API_KEY']

  # Send in background with threading:
  config.send_in_background = true

  # Skip rails related exceptions:
  config.exclude_rails_exceptions = false

  # Specify which rails exception to skip:
  config.excluded_exceptions = [
   'AbstractController::ActionNotFound',
   'ActionController::InvalidAuthenticityToken',
   'ActionController::RoutingError',
   'ActionController::UnknownAction',
   'ActiveRecord::RecordNotFound',
   'ActiveJob::DeserializationError'
  ]

  # Specify or add usage environments:
  config.usage_environments = %w[staging]
  # config.usage_environments << 'development'

  # Specify current user method:
  config.current_user_method = 'current_user'

  # Add scrub fields and headers:
  # config.scrub_fields << 'password'
  # config.scrub_headers << 'access_token'
end
