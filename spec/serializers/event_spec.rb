# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventSerializer do
  let(:event) { create(:event) }

  subject do
    EventSerializer.new(event).as_json
  end

  it {
    is_expected.to include(id: event.id,
                           title: event.title,
                           environment: event.environment,
                           status: event.status,
                           user_id: event.user_id,
                           project_id: event.project_id,
                           message: event.message,
                           backtrace: event.backtrace,
                           framework: event.framework,
                           url: event.url,
                           ip_address: event.ip_address,
                           headers: event.headers,
                           http_method: event.http_method,
                           params: event.params,
                           position: event.position,
                           server_data: event.server_data)
  }
end
