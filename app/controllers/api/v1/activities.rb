# frozen_string_literal: true

class API::V1::Activities < Grape::API
  helpers do
    def project_ids
      @project_ids ||= current_user.projects.pluck(:id)
    end

    def activities
      @activities ||= PublicActivity::Activity.order(created_at: :desc)
                                              .where(recipient_id: project_ids, recipient_type: 'Project')
                                              .page(declared_params[:page]).per(10)
    end
  end

  desc 'Return activities'
  params do
    optional :page, type: Integer, default: 1
  end

  get '/activities' do
    Activity::ActivityCollectionSerializer.new(activities, total_count: activities.total_count).as_json
  end
end
