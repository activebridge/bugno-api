# frozen_string_literal: true

namespace :events do
  task move_js_user_agent_to_headers: :environment do
    Event.find_each do |event|
      next unless event.&person_data.dig('javascript', 'browser')

      event.headers = {} unless event.headers
      event.headers['User-Agent'] = event.person_data['javascript']['browser']
      event.save
    end
  end
end
