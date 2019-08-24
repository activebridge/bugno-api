# frozen_string_literal: true

class API::V1::Projects::Integrations < Grape::API
  helpers do
    def project
      @project ||= Project.find(params[:project_id])
    end

    def integrations
      @integrations ||= project.integrations
    end

    def integration
      @integration ||= project.integrations.find(params[:id])
    end
  end

  namespace 'projects/:project_id' do
    resources :integrations do
      desc "Returns project's integrations"

      get do
        render(integrations)
      end

      desc 'Removes integration from project'
      delete ':id' do
        authorize(integration, :delete?)
        result = integration.destroy
        render_api(result)
      end
    end
  end
end
