# frozen_string_literal: true

class PublicUserSerializer < ApplicationSerializer
  attributes :id, :nickname, :image, :email
end
