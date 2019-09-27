# frozen_string_literal: true

class Activities::CreateService < ApplicationService
  def call
    trackable.create_activity(key, owner: owner, recipient: recipient, params: params)
  end

  private

  def params
    { status: { previous: trackable.saved_changes['status'].first,
                new: trackable.saved_changes['status'].last } }
  end
end
