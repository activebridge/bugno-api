# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :api_key, :slug
  attribute :stripe_public_key, if: proc { instance_options[:include_stripe_api_key] }

  def stripe_public_key
    ENV['STRIPE_DEVELOPMENT_PUBLIC_KEY']
  end
end
