# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'user:email'
  provider :slack, ENV['SLACK_KEY'], ENV['SLACK_SECRET'], scope: 'incoming-webhook,team:read'
  on_failure { |env| DeviseTokenAuth::OmniauthCallbacksController.action(:omniauth_failure).call(env) }
end
