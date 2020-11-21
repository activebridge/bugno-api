# frozen_string_literal: true

class API::V1::Projects::EventCollections < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def events
      @events ||= project.events.where(parent_id: nil)
                         .by_status(declared_params[:status])
                         .order(position: :asc)
                         .page(declared_params[:page])
                         .includes(:user)
    end
  end

  namespace 'projects/:project_id' do
    resources :event_collections do
      desc 'Updates events position'
      params do
        requires :status, type: String, values: Event.statuses.keys
        requires :direction, type: String, values: %w[asc desc]
        requires :column, type: String, values: %w[created_at occurrence_count]
      end

      patch do
        ::Events::PositionUpdateService
          .call(status: declared_params[:status], project: project,
                direction: declared_params[:direction], column: declared_params[:column])
        render(events,
               each_serializer: ParentEventSerializer,
               include: 'user',
               adapter: :json,
               meta: { total_count: events.total_count })
      end
    end
  end
end
