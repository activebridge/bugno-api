# frozen_string_literal: true

class API::V1::Projects::ProjectUsers < Grape::API
  helpers do
    def project
      @project ||= current_user.projects.find(params[:project_id])
    end

    def project_users
      @project_users ||= project.project_users.includes(:user)
    end

    def user_by_email
      @user_by_email ||= User.find_by(email: declared_params[:email])
    end

    def project_user
      @project_user ||= project.project_users.new(user: user_by_email, role: 1)
    end

    def matched_project_user
      @matched_project_user ||= project.project_users.find(params[:id])
    end
  end

  namespace 'projects/:project_id' do
    resources :project_users do
      desc "Returns project's users"

      get do
        status 200
        render(project_users)
      end

      desc 'Adds user to project'
      params do
        requires :email, type: String
      end

      post do
        authorize(project_user, :create?)
        if project_user.save
          status 201
          render(project_user)
        else
          render_error(project_user)
        end
      end

      desc 'Removes user from project'
      delete ':id' do
        authorize(matched_project_user, :delete?)
        if matched_project_user.destroy
          status 200
        else
          render_error(matched_project_user)
        end
      end
    end
  end
end
