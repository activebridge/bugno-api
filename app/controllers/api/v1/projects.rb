# frozen_string_literal: true

class API::V1::Projects < Grape::API
  helpers do
    def projects
      @projects ||= current_user.projects
    end

    def project
      @project ||= current_user.projects.create(declared_params[:project])
    end

    def matched_project
      @matched_project ||= current_user.projects.find(params[:id])
    end
  end

  resources :projects do
    desc "Returns projects"
    get do
      status 200
      present projects
    end

    desc 'Creates project'
    params do
      requires :project, type: Hash do
        requires :name, type: String
        optional :description, type: String
      end
    end

    post do
      if project.persisted?
        status 201
        present project
      else
        error!(project.errors.full_messages, 422)
      end
    end

    desc "Returns project"
    params do
      requires :id, type: String
    end

    get ':id' do
      status 200
      present matched_project
    end
  end
end
