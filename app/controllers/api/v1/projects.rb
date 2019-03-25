# frozen_string_literal: true

class API::V1::Projects < Grape::API
  helpers do
    def projects
      @projects ||= current_user.projects
    end

    def project
      @project ||= current_user.projects.create(declared_params['project'])
    end
  end

  resources :projects do
    desc "Returns user's projects"
    get do
      status 200
      present projects
    end

    params do
      requires :project, type: Hash do
        requires :name, type: String
        optional :description, type: String
      end
    end

    desc 'Creates project'
    post do
      if project.persisted?
        status 201
        present project
      else
        error!(project.errors.full_messages, 422)
      end
    end
  end
end
