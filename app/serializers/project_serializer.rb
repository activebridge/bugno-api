# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :api_key
  attribute :stripe_public_key do |_project, params|
    ENV['STRIPE_DEVELOPMENT_PUBLIC_KEY'] if params[:include_stripe_api_key]
  end
end
