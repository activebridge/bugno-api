# frozen_string_literal: true

class Api::V1::Plans < Grape::API
  helpers do
    def plans
      @plans ||= Plan.order(price: :asc)
    end
  end

  resources :plans do
    desc 'Returns all plans'
    route_setting :auth, disabled: true
    get do
      render(plans)
    end
  end
end
