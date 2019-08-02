# frozen_string_literal: true

class API::V1::Activities < Grape::API
  helpers do
    def project_ids
      @project_ids ||= current_user.projects.pluck(:id)
    end

    def activities
      @activities ||= PublicActivity::Activity.order('created_at desc')
                                              .where(recipient_id: project_ids, recipient_type: 'Project')
                                              .includes(:owner, :trackable, :recipient)
    end
  end

  get '/activities' do
    render(activities, serializer: ::Activity::ActivitySerializer)
  end
end
