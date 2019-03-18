# frozen_string_literal: true

namespace :grape do
  desc 'Print compiled grape routes'
  task routes: :environment do
    API::Base.routes.each do |route|
      method = (route.request_method || '*').ljust(10)
      puts "#{method} #{route.path}"
    end
  end
end
