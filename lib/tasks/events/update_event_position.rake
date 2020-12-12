# frozen_string_literal: true

namespace :events do
  task update_event_position: :environment do
    order = 'COALESCE(last_occurrence_at, created_at) DESC'
    Project.find_each do |project|
      Event.statuses.keys.each do |status|
        events = Event.where(project: project, parent_id: nil, status: status)
                      .order(Arel.sql(order))
                      .pluck(Arel.sql("id, ROW_NUMBER() OVER(ORDER BY #{order}) AS position"))
        Event.import(%i[id position], events, on_duplicate_key_update: [:position], validate: false)
      end
    end
  end
end
