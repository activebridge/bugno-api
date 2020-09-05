# frozen_string_literal: true

require 'open-uri'

module Events
  class ResolveSourceCodeService < ApplicationService
    def call
      unless File.exist?(path)
        return if invalid_map?

        save_source_map
      end
      @event.backtrace.unshift(result) if result
    end

    private

    def result
      @result ||= resolve_trace
    end

    def invalid_map?
      JSON.parse(download)
      false
    rescue StandardError
      true
    end

    def path
      @path ||= "public/#{filename}"
    end

    def filename
      @filename ||= "#{@trace['filename'].split('/')[-1]}.map"
    end

    # rubocop:disable Security/Open
    def save_source_map
      open(path, 'wb') { |file| file << download }
    end

    def download
      @download ||= begin
        open(source_map_url).read
                    rescue StandardError
                      nil
      end
    end
    # rubocop:enable Security/Open

    def source_map_url
      @source_map_url ||= "#{@trace['filename']}.map"
    end

    def resolve_trace
      res = `node #{Constants::Path::SOURCE_MAP_PARSER} map:#{path} line:#{@trace['lineno']} column:#{@trace['colno']}`
      parsed = JSON.parse(res)
      { colno: parsed['column'], filename: parsed['source'], lineno: parsed['line'], method: parsed['name'] }
    end
  end
end
