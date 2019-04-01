# frozen_string_literal: true

class API::V1::Projects::Events < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def events
      @events ||= project.events
    end

    def matched_event
      @matched_event ||= project.events.find(params[:id])
    end
  end

  namespace 'projects/:project_id' do
    resources :events do
      desc 'Returns events'
      get do
        status 200
        render(events)
      end

      desc 'Returns event'
      params do
        requires :id, type: String
      end

      get ':id' do
        status 200
        render(matched_event)
      end

      desc 'Updates event'
      params do
        requires :event, type: Hash do
          optional :status, type: Integer, values: Event.statuses.values
          optional :user_id, type: Integer
        end
      end

      patch ':id' do
        if matched_event.update(declared_params[:event])
          status 200
          render(matched_event)
        else
          render_error(matched_event)
        end
      end
    end
  end
end
