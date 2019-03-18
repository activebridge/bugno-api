# frozen_string_literal: true

Rails.application.routes.draw do
  mount API::Base, at: '/api'
end
