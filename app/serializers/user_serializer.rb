# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  include Verifiable
  attributes :id, :nickname, :name, :email, :action_cable_token

  def action_cable_token
    verifier.generate(id: object.id)
  end
end
