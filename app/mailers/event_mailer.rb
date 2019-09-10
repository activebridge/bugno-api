# frozen_string_literal: true

class EventMailer < ApplicationMailer
  def create(event)
    @event = event
    @users = event.project.users
    @first_chunk_of_code = first_chunk_of_code
    @event_url = event_url
    @request_url = request_url
    mail(to: @users.pluck(:email),
         subject: I18n.t('event_mailer.create.subject',
                         project_name: @event.project.name, event_environment: @event.environment,
                         event_title: @event.title, event_message: @event.message.truncate(140)))
  end

  private

  def request_url
    @request_url ||= @event.url
  end

  def event_url
    "#{I18n.t("web_client_url.#{Rails.env}")}/projects/#{@event.project.slug}/event/#{@event.id}"
  end

  def first_chunk_of_code
    return if @event.framework == 'browser-js'

    @first_chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
