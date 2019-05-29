# frozen_string_literal: true

class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def omniauth_success
    get_resource_from_auth_hash
    set_token_on_resource
    create_auth_params

    @resource.skip_confirmation! if confirmable_enabled?

    sign_in(:user, @resource, store: false, bypass: false)

    ::OmniauthCallbacks::OmniauthSuccessService.call(params: omniauth_params, user: @resource)

    yield @resource if block_given?
    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end
end
