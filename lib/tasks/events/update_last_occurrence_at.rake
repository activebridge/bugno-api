# frozen_string_literal: true

namespace :events do
  task update_last_occurrence_at: :environment do
    Event.where('parent_id is NULL AND occurrence_count > 0').find_each do |event|
      created_at = event.occurrences.order(created_at: :desc).first.created_at
      event.update(last_occurrence_at: created_at)
    end
  end
end
