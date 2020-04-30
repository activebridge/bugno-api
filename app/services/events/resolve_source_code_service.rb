# frozen_string_literal: true

require 'open-uri'

module Events
  class ResolveSourceCodeService < ApplicationService
    def call
      unless File.exist?(path)
        return if download.blank?

        save_source_map
      end
      resolve_trace
    end

    private

    def path
      @path ||= "tmp/#{filename}"
    end

    def filename
      @filename ||= "#{@trace['filename'].split('/')[-1]}.map"
    end

    def save_source_map
      download.is_a?(File) ? download : IO.copy_stream(download, path)
    end

    # rubocop:disable Security/Open
    def download
      @download ||= begin
        open(source_map_url)
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
