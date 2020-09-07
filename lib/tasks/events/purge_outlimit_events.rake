# frozen_string_literal: true

namespace :events do
  task purge_outlimit_events: :environment do
    Event.where('occurrence_count >= 100 AND parent_id IS NULL').ids.each do |parent_id|
      recent_ids = Event.where(parent_id: parent_id).order(created_at: :desc).limit(100).ids
      Event.where(parent_id: parent_id).where.not(id: recent_ids).delete_all
    end
  end
end
