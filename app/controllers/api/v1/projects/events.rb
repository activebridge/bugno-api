# frozen_string_literal: true

class API::V1::Projects::Events < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def event
      @event ||= project.events.find(params[:id])
    end

    def events
      @events ||= project.events.where(parent_id: nil)
                         .by_status(declared_params[:status])
                         .order(position: :asc)
                         .page(declared_params[:page])
                         .includes(:user)
    end

    def destroyable_events
      @destroyable_events ||= project.events.where(parent_id: nil).by_status(declared_params[:status])
    end
  end

  namespace 'projects/:project_id' do
    resources :events do
      desc 'Returns all or parent events if status specified'
      params do
        requires :project_id, type: String
        optional :page, type: Integer, default: 1
        optional :status, type: String, values: Event.statuses.keys
      end

      get do
        render events,
               each_serializer: ParentEventSerializer,
               include: 'user',
               adapter: :json,
               meta: { total_count: events.total_count }
      end

      desc 'Creates event'
      route_setting :auth, disabled: true
      params do
        requires :project_id, type: String
        requires :title, type: String
        requires :message, type: String
        optional :created_at, type: Integer
        optional :framework, type: String
        optional :environment, type: String
        optional :backtrace, type: Array
        optional :url, type: String
        optional :ip_address, type: String
        optional :headers, type: Hash
        optional :http_method, type: String
        optional :params, type: Hash
        optional :server_data, type: Hash
        optional :person_data, type: Hash
        optional :background_data, type: Hash
        optional :route_params, type: Hash
      end

      post do
        event = ::Events::CreateService.call(declared_params: declared_params)
        render_api(*event)
      end

      desc 'Returns event'
      get ':id' do
        render_api(event)
      end

      desc 'Returns occurrences'
      params do
        requires :project_id, type: String
        requires :id, type: String
        optional :page, type: Integer, default: 1
      end

      get 'occurrences/:id' do
        occurrences = ::Events::OccurrencesService.call(params: declared_params)
        render occurrences,
               each_serializer: OccurrenceSerializer,
               adapter: :json,
               meta: { total_count: occurrences.total_count }
      end

      desc 'Updates event'
      params do
        requires :project_id, type: String
        requires :id, type: Integer
        requires :event, type: Hash do
          optional :status, type: String, values: Event.statuses.keys
          optional :position, type: Integer
          optional :user_id, type: Integer
        end
      end

      patch ':id' do
        event = ::Events::UpdateService.call(declared_params: declared_params, user: current_user)
        render_api(event)
      end

      desc 'Deletes event'
      delete ':id' do
        render_api(event.destroy)
      end

      desc 'Deletes event collection'
      params do
        optional :status, type: String
      end

      delete do
        authorize(project, :destroy?)
        render_api(destroyable_events.destroy_all)
      end
    end
  end
end
