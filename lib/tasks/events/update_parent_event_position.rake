# frozen_string_literal: true

namespace :events do
  task update_parent_event_position: :environment do
    Project.find_each do |project|
      Event.statuses.keys.each do |status|
        project.events.where(status: status, parent_id: nil).update_all(position: nil)
        project.events
               .where(parent_id: nil, status: status)
               .order('COALESCE(last_occurrence_at, created_at) DESC')
               .each_with_index do |event, index|
          event.update_column(:position, index)
        end
      end
    end
  end
end
