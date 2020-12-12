# frozen_string_literal: true

class API::V1::Projects::EventCollections < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def events
      @events ||= project.events.includes(:user)
                         .where(parent_id: nil)
                         .by_status(declared_params[:status])
                         .order(position: :asc)
                         .page(declared_params[:page])
    end

    def events_payload
      { events: ActiveModel::Serializer::CollectionSerializer.new(events, serializer: ParentEventSerializer).as_json }
        .merge({ project_id: project.id, action: UserChannel::ACTIONS::BULK_UPDATE, status: declared_params[:status] })
    end

    def broadcast_events
      project.project_users.pluck(:user_id).each do |user_id|
        ActionCable.server.broadcast("user_#{user_id}", events_payload)
      end
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
        broadcast_events
        status 200
      end
    end
  end
end
