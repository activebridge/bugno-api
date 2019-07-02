# frozen_string_literal: true

class EventMailer < ApplicationMailer
  def create(event)
    @event = event
    @users = event.project.users
    @first_chunk_of_code = first_chunk_of_code
    mail(to: @users.pluck(:email),
         subject: I18n.t('event_mailer.create.subject',
                         project_name: @event.project.name, event_environment: @event.environment,
                         event_title: @event.title, event_message: @event.message.capitalize))
  end

  private

  def first_chunk_of_code
    return if @event.framework == 'browser-js'

    @first_chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
