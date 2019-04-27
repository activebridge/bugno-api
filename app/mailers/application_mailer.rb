# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Radar Notification'
  layout 'mailer'
end
