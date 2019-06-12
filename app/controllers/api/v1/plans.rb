# frozen_string_literal: true

class API::V1::Plans < Grape::API
  resources :plans do
    desc 'Returns all plans'
    route_setting :auth, disabled: true
    get do
      @plans = Plan.all
      render(@plans)
    end
  end
end
