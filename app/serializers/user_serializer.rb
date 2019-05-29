# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :id, :nickname, :name, :email
end
