# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :name, :description, :api_key
end
