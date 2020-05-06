# frozen_string_literal: true

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  throttle('req/ip', limit: 60, period: 60.seconds, &:ip)
end
