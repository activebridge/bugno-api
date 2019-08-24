# frozen_string_literal: true

class UserChannel < ApplicationCable::Channel
  module ACTIONS
    CREATE_EVENT = 'CREATE_EVENT'
    UPDATE_EVENT = 'UPDATE_EVENT'
    CREATE_SLACK_INTEGRATION = 'CREATE_SLACK_INTEGRATION'
  end

  def subscribed
    stream_from("user_#{current_user.id}")
  end
end
