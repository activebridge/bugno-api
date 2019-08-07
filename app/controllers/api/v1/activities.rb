# frozen_string_literal: true

class API::V1::Activities < Grape::API
  helpers do
    def project_ids
      @project_ids ||= current_user.project_ids
    end

    def activities
      @activities ||= PublicActivity::Activity.order(created_at: :desc)
                                              .where(recipient_id: project_ids, recipient_type: 'Project')
                                              .includes(:owner, :trackable, :recipient)
                                              .page(declared_params[:page]).per(20)
    end
  end

  desc 'Return activities'
  params do
    optional :page, type: Integer, default: 1
  end

  get '/activities' do
    Activity::CollectionSerializer.new(activities, total_count: activities.total_count).as_json
  end
end
