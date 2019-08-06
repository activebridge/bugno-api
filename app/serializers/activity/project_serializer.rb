# frozen_string_literal: true

class Activity::ProjectSerializer < ApplicationSerializer
  attributes :id, :name, :api_key, :slug, :active_event_count
end
