# frozen_string_literal: true

class API::V1::Projects::ProjectUsers < Grape::API
  helpers do
    def project
      @project ||= Project.find(params[:project_id])
    end

    def project_user
      @project_user ||= ProjectUser.find(params[:id])
    end
  end

  namespace 'projects/:project_id' do
    resources :project_users do
      desc "Returns project's users"

      get do
        project_users = ::ProjectUsers::IndexService.call(params: params, user: current_user)
        status 200
        render(project_users)
      end

      desc 'Adds user to project'
      params do
        requires :email, type: String, allow_blank: false, regexp: Devise.email_regexp
      end

      post do
        authorize(project, :update?)
        project_user = ::ProjectUsers::CreateService.call(declared_params: declared_params,
                                                          params: params,
                                                          user: current_user)
        render_api(project_user)
      end

      desc 'Removes user from project'
      delete ':id' do
        authorize(project_user, :delete?)
        project_user = ::ProjectUsers::DeleteService.call(params: params, user: current_user)
        render_api(project_user)
      end
    end
  end
end
