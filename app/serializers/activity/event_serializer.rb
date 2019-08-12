# frozen_string_literal: true

class Activity::EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :framework, :occurrence_count
end
