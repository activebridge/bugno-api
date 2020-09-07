# frozen_string_literal: true

namespace :events do
  task reset_occurrence_count: :environment do
    Event.where(parent_id: nil).where.not(occurrence_count: 0).ids.each do |id|
      Event.reset_counters(id, :occurrences)
    end
  end
end
