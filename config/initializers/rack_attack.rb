# frozen_string_literal: true

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  throttle('req/ip', limit: 15, period: 10.seconds) do |req|
    req.ip if req.post?
  end
end
