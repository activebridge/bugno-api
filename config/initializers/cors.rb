# frozen_string_literal: true

Rails.application.config.middleware.use Rack::Cors do
  allow do
    origins '*'
    resource '*',
             headers: :any,
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post options delete put patch]
  end
end
