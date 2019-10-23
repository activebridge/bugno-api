# frozen_string_literal: true

class Api::Base < Grape::API
  helpers Pundit
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers
  rescue_from ActiveRecord::RecordNotFound do |_e|
    error_response(message: I18n.t('api.errors.not_found'), status: 404)
  end

  rescue_from Pundit::NotAuthorizedError do
    error_response(message: I18n.t('pundit.default'), status: 403)
  end

  mount Api::V1::Base
  mount Api::V2::Base
  mount Api::V3::Base
  mount Api::V4::Base

  get 'status' do
    { status: 'OK' }
  end

  add_swagger_documentation(
    info: {
      title: 'Bugno API'
    },
    doc_version: '1.0.0'
  )
end
