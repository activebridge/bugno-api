# frozen_string_literal: true

class API::Base < Grape::API
  mount API::V1::Base
  mount API::V2::Base
  mount API::V3::Base
  mount API::V4::Base

  get 'status' do
    { status: 'OK' }
  end
end
