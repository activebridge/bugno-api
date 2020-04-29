# frozen_string_literal: true

require 'open-uri'

module Events
  class ResolveSourceCodeService < ApplicationService
    def call
      `node #{Constants::Path::SOURCE_MAP_PARSER} map:#{source_map.path}
                                                  line:#{@event.backtrace['lineno']}
                                                  column:#{@event.backtrace['colno']}`
    end

    private

    # rubocop:disable Security/Open
    def source_map
      @source_map ||= open(source_map_url)
    end

    def source_map_url
      @source_map_url ||= "#{@event.backtrace['filename']}.map"
    end
  end
end
