# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :api_key
  attribute :stripe_publishable_key do |_project, params|
    ENV['STRIPE_DEVELOPMENT_PUBLISHABLE_KEY'] if params[:include_stripe]
  end
end
