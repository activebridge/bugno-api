# frozen_string_literal: true

class API::V1::Activities < Grape::API
  helpers do
    def activities
      @activities ||= current_user.project_activities
                                  .includes(:owner, :trackable, :recipient)
                                  .order(created_at: :desc)
                                  .page(declared_params[:page]).per(20)
    end
  end

  desc 'Return activities'
  params do
    optional :page, type: Integer, default: 1
  end

  get '/activities' do
    render(activities,
           each_serializer: Activity::SingleSerializer,
           adapter: :json,
           meta: { total_count: activities.total_count })
  end
end
