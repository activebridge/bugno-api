# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'BugHub Notification'
  layout 'mailer'
end
