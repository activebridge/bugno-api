# frozen_string_literal: true

class Activity::UserSerializer < ApplicationSerializer
  attributes :id, :nickname, :email
end
