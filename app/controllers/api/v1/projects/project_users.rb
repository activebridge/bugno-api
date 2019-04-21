# frozen_string_literal: true

class API::V1::Projects::ProjectUsers < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def project_users
      @project_users ||= project.project_users
    end

    def user_by_email
      @user_by_email ||= User.find_by(email: declared_params[:email])
    end

    def role
      @role ||= current_user.project_users.find_by(project: project).role
    end

    def user
      @user ||= project.project_users.create(user: user_by_email, role: 1) if role == 'owner'
    end
  end

  namespace 'projects/:project_id' do
    resources :project_users do
      desc "Returns project's users"

      get do
        status 200
        render(project_users)
      end

      desc 'Sets user to project'
      params do
        requires :email, type: String
      end

      post do
        if user&.persisted?
          status 201
        else
          render_error(user)
        end
      end
    end
  end
end
