# frozen_string_literal: true

class EventMailer < ApplicationMailer
  before_action :add_inline_logo

  def exception(event, addresses)
    @event = event
    @chunk_of_code = chunk_of_code
    @link = link
    mail(to: addresses,
         subject: I18n.t('mailer.exception.subject',
                         project_name: @event.project.name, environment: @event.environment, title: @event.title))
  end

  def occurrence(occurence, addresses)
    @event = occurence
    @parent_event = occurence.parent
    @link = link
    @occurrence_count = @event.parent.occurrence_count
    mail(to: addresses,
         subject: I18n.t('mailer.occurrence.subject',
                         project_name: @event.project.name, environment: @event.environment,
                         title: @event.title, times: @occurrence_count))
  end

  private

  def add_inline_logo
    attachments.inline['bugno-logo.png'] = File.read('app/assets/images/bugno-logo.png')
  end

  def link
    id = @event.parent? ? @event.id : @parent_event.id
    "#{I18n.t("web_url.#{Rails.env}")}/projects/#{@event.project.slug}/event/#{id}"
  end

  def chunk_of_code
    return if @event.framework == 'browser-js'

    @chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
