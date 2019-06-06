# frozen_string_literal: true

class API::V1::Projects::Events < Grape::API
  namespace 'projects/:project_id' do
    resources :events do
      desc 'Returns all or parent events if status specified'
      params do
        requires :project_id, type: Integer
        requires :page, type: Integer
        optional :status, type: String, values: Event.statuses.keys
      end

      get do
        events = ::Events::IndexService.call(declared_params: declared_params,
                                             user: current_user)
        render_api(events)
      end

      desc 'Creates event'
      route_setting :auth, disabled: true
      params do
        requires :project_id, type: String
        requires :title, type: String
        optional :environment, type: String
        optional :message, type: String
        optional :backtrace, type: Array
        optional :framework, type: String
        optional :url, type: String
        optional :ip_address, type: String
        optional :headers, type: Hash
        optional :http_method, type: String
        optional :params, type: Hash
        optional :server_data, type: Hash
      end

      post do
        event = ::Events::CreateService.call(declared_params: declared_params)
        status 201
        render_api(event)
      end

      desc 'Returns event'

      get ':id' do
        event = ::Events::ShowService.call(params: params,
                                           user: current_user)
        render_api(event)
      end

      desc 'Returns occurrences'
      params do
        requires :project_id, type: Integer
        requires :parent_id, type: String
      end

      get 'occurrences/:parent_id' do
        events = ::Events::OccurrencesService.call(declared_params: declared_params,
                                                   user: current_user)
        render_api(events)
      end

      desc 'Updates event'
      params do
        requires :project_id, type: Integer
        requires :id, type: Integer
        requires :event, type: Hash do
          optional :status, type: String, values: Event.statuses.keys
          optional :position, type: Integer
          optional :user_id, type: Integer
        end
      end

      patch ':id' do
        event = ::Events::UpdateService.call(declared_params: declared_params,
                                             user: current_user)
        render_api(event)
      end
    end
  end
end
