# frozen_string_literal: true

class EventMailer < ApplicationMailer
  def create(event)
    @event = event
    @users = event.project.users
    @chunk_of_code = chunk_of_code
    @link = link
    mail(to: @users.pluck(:email),
         subject: I18n.t('event_mailer.create.subject',
                         project_name: @event.project.name, environment: @event.environment, title: @event.title))
  end

  def occurrence(_parent_event, _occurence, users)
    @link = link
    @times = @event.parent.occurrence_count
    mail(to: users.pluck(:email),
         subject: I18n.t('event_mailer.occurrence.subject',
                         project_name: @event.project.name, environment: @event.environment,
                         title: @event.title, times: @times))
  end

  private

  def link
    "#{I18n.t("web_url.#{Rails.env}")}/projects/#{@event.project.slug}/event/#{@event.id}"
  end

  def chunk_of_code
    return if @event.framework == 'browser-js'

    @chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
