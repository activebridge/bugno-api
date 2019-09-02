# frozen_string_literal: true

class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def redirect_callbacks
    devise_mapping = get_devise_mapping
    redirect_route = get_redirect_route(devise_mapping)
    handle_session_data
    redirect_to redirect_route
  end

  def omniauth_success
    if integration?
      ::OmniauthCallbacks::IntegrationService.call(params: omniauth_params, omniauth_extra: omniauth_extra,
                                                   provider: provider)
      return render_data_or_redirect('success', {})
    end
    handle_resource
    sign_in(:user, @resource, store: false, bypass: false)
    ::OmniauthCallbacks::OmniauthSuccessService.call(params: omniauth_params, user: @resource)
    yield @resource if block_given?
    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end

  def omniauth_failure
    render_data_or_redirect('error', {})
  end

  private

  def provider
    @provider ||= session['dta.omniauth.auth']['provider']
  end

  def integration?
    omniauth_params['integration_provider']
  end

  def omniauth_extra
    session['dta.omniauth.extra']
  end

  def handle_session_data
    session['dta.omniauth.extra'] = request.env['omniauth.auth']['extra']
    session['dta.omniauth.auth'] = request.env['omniauth.auth'].except('extra')
    session['dta.omniauth.params'] = request.env['omniauth.params']
  end

  def handle_resource
    get_resource_from_auth_hash
    set_token_on_resource
    create_auth_params
  end
end
