# frozen_string_literal: true

class API::V1::Base < Grape::API
  auth :grape_devise_token_auth, resource_class: :user
  helpers GrapeDeviseTokenAuth::AuthHelpers

  helpers do
    def declared_params
      declared(params, include_missing: false)
    end

    def render_error(record)
      record.respond_to?(:errors) ? error!(record.errors.full_messages.to_sentence, 422) : status(422)
    end

    def render_api(object, status = 200)
      if object.nil? || object.respond_to?(:errors) && object.errors.present?
        render_error(object)
      else
        status(status)
        render(object)
      end
    end
  end

  version 'v1'

  desc 'Returns the current API version, v1.'
  get 'version' do
    { api_version: '1.0.0' }
  end

  before { authenticate_user! unless env[Grape::Env::GRAPE_ROUTING_ARGS] && route.settings.dig(:auth, :disabled) }

  mount API::V1::Plans
  mount API::V1::Projects
  mount API::V1::Projects::Events
  mount API::V1::Projects::ProjectUsers
  mount API::V1::Projects::Subscriptions
  mount API::V1::Projects::Integrations
end
