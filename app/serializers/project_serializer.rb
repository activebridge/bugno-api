# frozen_string_literal: true

class ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :description, :api_key
end
