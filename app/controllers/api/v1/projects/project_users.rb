# frozen_string_literal: true

class API::V1::Projects::ProjectUsers < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def project_users
      @project_users ||= project.project_users
    end

    def users
      @users ||= project.users
    end
  end

  namespace 'projects/:project_id' do
    resources :project_users do
      desc "Returns project's users"

      get do
        status 200
        render(project_users)
      end
    end
  end
end
