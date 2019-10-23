# frozen_string_literal: true

class EventMailer < ApplicationMailer
  def create(event, addresses)
    @event = event
    @first_chunk_of_code = first_chunk_of_code
    @event_link = event_link
    @request_url = event.url
    mail(to: addresses,
         subject: I18n.t('event_mailer.create.subject',
                         project_name: @event.project.name, event_environment: @event.environment,
                         event_title: @event.title, event_message: @event.message.truncate(140)))
  end

  private

  def event_link
    "#{I18n.t("web_client_url.#{Rails.env}")}/projects/#{@event.project.slug}/event/#{@event.id}"
  end

  def first_chunk_of_code
    return if @event.framework == 'browser-js'

    @first_chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
