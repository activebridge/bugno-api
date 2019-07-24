# frozen_string_literal: true

module Verifiable
  def verifier
    @verifier = ActiveSupport::MessageVerifier.new(ENV['SECRET_KEY_BASE'],
                                                   digest: 'SHA256', serializer: YAML)
  end
end
