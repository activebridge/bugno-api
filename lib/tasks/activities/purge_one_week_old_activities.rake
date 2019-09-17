# frozen_string_literal: true

namespace :activities do
  task purge_one_week_old_activities: :environment do
    PublicActivity::Activity.where('created_at < ?', 1.week.ago).destroy_all
  end
end
