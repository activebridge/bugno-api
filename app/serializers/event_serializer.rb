# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id
end
