# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Verifiable
    identified_by :current_user

    def connect
      check
      self.current_user = user
    end

    protected

    def check
      reject_unauthorized_connection unless user
    end

    def user
      User.find(verified_object[:id]) if verified_object[:id]
    end

    def verified_object
      @verified_object ||= verifier.verify(request.params[:action_cable_token])
    rescue StandardError
      {}
    end
  end
end
