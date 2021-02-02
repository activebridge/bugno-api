# frozen_string_literal: true

class EventMailer < ApplicationMailer
  before_action :add_inline_logo, :assign_action_name, only: %i[exception occurrence]

  def exception(event, addresses)
    @event = event
    @chunk_of_code = chunk_of_code
    @link = link
    mail(to: addresses,
         subject: default_i18n_subject(project_name: @event.project.name,
                                       environment: @event.environment,
                                       title: @event.title))
  end

  def occurrence(occurence, addresses)
    @event = occurence
    @parent_event = occurence.parent
    @link = link
    @occurrence_count = @event.parent.occurrence_count
    mail(to: addresses,
         subject: default_i18n_subject(project_name: @event.project.name,
                                       environment: @event.environment,
                                       title: @event.title, times: @occurrence_count))
  end

  def assign(event, assigner)
    @event = event
    @link = link
    @assignee = event.user
    @assigner = assigner
    add_assigner_photo
    mail(to: @assignee.email,
         subject: default_i18n_subject(project_name: @event.project.name,
                                       environment: @event.environment,
                                       title: @event.title, assigner_name: @assigner.nickname))
  end

  def high_frequency(event, addresses)
    @event = event
    @link = project_link
    @frequency = frequency
    add_high_frequency_image
    mail(to: addresses,
         subject: default_i18n_subject(project_name: @event.project.name,
                                       environment: @event.environment,
                                       title: @event.title, frequency: @frequency))
  end

  private

  def frequency
    Event.since(1.minute.ago).where(title: @event.title, project_id: @event.project_id).count
  end

  def assign_action_name
    @action_name = action_name
  end

  # rubocop:disable Security/Open
  def add_assigner_photo
    attachments.inline['assigner.png'] = open(@assigner.image).read
  end
  # rubocop:enable Security/Open

  def add_inline_logo
    attachments.inline['bugno-logo.png'] = File.read('app/assets/images/bugno-logo.png')
  end

  def add_high_frequency_image
    attachments.inline['high_frequency.png'] = File.read('app/assets/images/high_frequency.png')
  end

  def link
    id = @event.parent? ? @event.id : @parent_event.id
    "#{I18n.t("web_url.#{Rails.env}")}/projects/#{@event.project.slug}/event/#{id}"
  end

  def project_link
    "#{I18n.t("web_url.#{Rails.env}")}/projects/#{@event.project.slug}"
  end

  def chunk_of_code
    return if @event.framework == Constants::Event::BROWSER_JS

    @chunk_of_code ||= @event.backtrace.find do |trace_line|
      trace_line['filename'].include?(@event.server_data['root'])
    end
  end
end
