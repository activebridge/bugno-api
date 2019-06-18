# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :api_key
  attribute :stripe_public_key, if: :include_stripe_api_key

  def include_stripe_api_key
    instance_options[:include_stripe_api_key]
  end

  def stripe_public_key
    ENV['STRIPE_DEVELOPMENT_PUBLIC_KEY']
  end
end
