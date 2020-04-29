# frozen_string_literal: true

require 'open-uri'

module Events
  class ResolveSourceCodeService < ApplicationService
    def call
      resolved_trace
    end

    private

    # rubocop:disable Security/Open
    def source_map
      @source_map ||= download.is_a?(File) ? download : IO.copy_stream(download, path)
    end

    def download
      @download ||= open(source_map_url)
    end

    def path
      @path ||= download.is_a?(File) ? source_map.path : "tmp/#{download.base_uri.to_s.split('/')[-1]}"
    end

    def source_map_url
      @source_map_url ||= "#{trace['filename']}.map"
    end

    def trace
      @trace ||= @event.backtrace.first
    end

    def resolved_trace
      result = `node #{Constants::Path::SOURCE_MAP_PARSER} map:#{path} line:#{trace['lineno']} column:#{trace['colno']}`
      parsed = JSON.parse(result)
      { colno: parsed['column'], filename: parsed['source'], lineno: parsed['line'], method: parsed['name'] }
    end
  end
end
