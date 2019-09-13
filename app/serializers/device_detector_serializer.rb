# frozen_string_literal: true

class DeviceDetectorSerializer < ApplicationSerializer
  attribute :parsed_data, if: proc { client.known? }

  def parsed_data
    { browser: browser,
      os: os,
      device: device }
  end

  def browser
    "#{client.name} #{client.full_version}"
  end

  def os
    "#{client.os_name} #{client.os_full_version}"
  end

  def device
    "#{client.device_name} #{client.device_type}"
  end

  def client
    @client ||= DeviceDetector.new(object)
  end
end
