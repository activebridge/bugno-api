# frozen_string_literal: true

class API::V1::Projects::Subscriptions < Grape::API
  helpers do
    def subscription
      @subscription ||= project.subscription
    end

    def project
      @project ||= current_user.projects.find(params[:project_id])
    end
  end

  namespace 'projects/:project_id' do
    resources :subscriptions do
      desc 'Returns project subscription'
      get do
        render(subscription)
      end

      desc 'Adds subscription to project'
      params do
        requires :project_id, type: String
        requires :stripe_source, type: String
        requires :plan_id, type: Integer
      end

      post do
        return error!(I18n.t('api.errors.subscription_exists'), 422) if project.subscription&.active?

        subscription = ::Subscriptions::CreateService.call(params: declared_params, user: current_user)

        return error!(subscription.message, subscription.http_status) if subscription.is_a?(Stripe::StripeError)

        render_api(subscription)
      end

      desc 'Updates plan'
      params do
        requires :id, type: String
        requires :stripe_source, type: String
        requires :plan_id, type: Integer
      end

      patch ':id' do
        subscription = ::Subscriptions::UpdateService.call(params: declared_params, user: current_user)
        render_api(subscription)
      end

      desc 'Cancel subscription'
      params do
        requires :id, type: Integer
      end

      patch ':id/cancel' do
        subscription = ::Subscriptions::CancelSubscriptionService.call(params: declared_params)
        render_api(subscription)
      end
    end
  end
end
