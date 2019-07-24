# frozen_string_literal: true

class UserChannel < ApplicationCable::Channel
  module ACTIONS
    CREATE_EVENT = 'CREATE_EVENT'
    UPDATE_EVENT = 'UPDATE_EVENT'
  end

  def subscribed
    stream_from("user_#{current_user.id}")
  end
end
