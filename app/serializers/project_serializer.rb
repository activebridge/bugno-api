# frozen_string_literal: true

class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :api_key, :description
end
