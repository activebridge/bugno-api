# frozen_string_literal: true

module Verifiable
  def verifier
    @verifier = ActiveSupport::MessageVerifier.new(Rails.application.credentials.secret_key_base,
                                                   digest: 'SHA256', serializer: YAML)
  end
end
