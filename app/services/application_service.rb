# frozen_string_literal: true

class ApplicationService
  attr_reader :errors

  def initialize(opts = {})
    @errors = []
    opts.each do |name, value|
      instance_variable_set("@#{name}", value)
      self.class.send(:attr_reader, name)
    end
  end

  def self.call(opts = {})
    new(opts).call
  end
end
