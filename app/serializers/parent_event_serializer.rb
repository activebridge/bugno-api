# frozen_string_literal: true

class ParentEventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :framework, :position, :created_at, :parent_id,
             :occurrence_count, :last_occurrence_at
  belongs_to :user, serializer: PublicUserSerializer
end
