# frozen_string_literal: true

class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  throttle('req/ip', limit: 20, period: 20.seconds, &:ip)
end
