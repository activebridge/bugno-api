# frozen_string_literal: true

class Api::V1::Projects < Grape::API
  helpers do
    def projects
      @projects ||= current_user.projects.order(updated_at: :desc)
    end

    def project
      @project ||= current_user.projects.create(declared_params[:project])
    end

    def matched_project
      @matched_project ||= current_user.projects.find(params[:id])
    end
  end

  resources :projects do
    desc 'Returns projects'
    get do
      status 200
      render(projects.includes(:subscription))
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
        render(project)
      else
        render_error(project)
      end
    end

    desc 'Returns project'
    params do
      requires :id, type: String
    end

    get ':id' do
      render(matched_project, extra: { include_stripe_api_key: true })
    end

    desc 'Updates project'
    params do
      requires :project, type: Hash do
        requires :name, type: String
        optional :description, type: String
      end
    end

    patch ':id' do
      authorize(matched_project, :update?)
      if matched_project.update(declared_params[:project])
        status 200
        render(matched_project)
      else
        render_error(matched_project)
      end
    end

    desc 'Deletes project'
    params do
      requires :id, type: String
    end

    delete ':id' do
      authorize(matched_project, :destroy?)
      if matched_project.destroy
        status 200
      else
        render_error(matched_project)
      end
    end
  end
end
