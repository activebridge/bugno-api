# frozen_string_literal: true

class ProjectUserSerializer < ApplicationSerializer
  attributes :id, :project_id, :user_id, :role
  attribute :user do |object|
    UserSerializer.new(object.user).serializable_hash
  end
end
