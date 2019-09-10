# frozen_string_literal: true

namespace :events do
  task move_js_user_agent_to_headers: :environment do
    Event.find_each do |event|
      next if (event.person_data && event.person_data.dig('javascript', 'browser')).nil?

      event.headers = {} if event.headers.nil?
      event.headers['User-Agent'] = event.person_data['javascript']['browser']
      event.save
    end
  end
end
