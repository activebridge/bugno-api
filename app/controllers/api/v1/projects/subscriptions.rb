# frozen_string_literal: true

class API::V1::Projects::Subscriptions < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end
  end

  namespace 'projects/:project_id' do
    resources :subscriptions do
      desc 'Returns project subscription'
      get do
        @subscription = project.subscription
        render_api(@subscription)
      end

      desc 'Adds subscription to project'
      params do
        requires :project_id, type: Integer
        requires :stripe_token, type: String
        requires :plan_id, type: Integer
      end

      post do
        error!(I18n.t('api.errors.subscription_exists'), 422) if project.subscription&.status == 'active'

        transaction = ::Transactions::ChargeService.call(params: declared_params, user: current_user)
        error!(transaction.message, transaction.http_status) if transaction.is_a?(Stripe::StripeError)

        subscription = ::Subscriptions::CreateService.call(params: declared_params)
        render_api(subscription)
      end
    end
  end
end
