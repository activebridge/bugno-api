# frozen_string_literal: true

class PlanSerializer < ApplicationSerializer
  attributes :id, :name, :description, :price, :event_limit
end
