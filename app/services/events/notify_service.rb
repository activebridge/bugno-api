# frozen_string_literal: true

class Events::NotifyService < ApplicationService
  def call
    return unless notify? && notifiable_status?

    EventMailer.send(mailer_action, @event, user_emails).deliver_later
    Integration.notify(notify_attributes)
  end

  private

  def mailer_action
    @mailer_action ||= begin
      return :high_frequency if high_frequency?

      @event.parent? ? :exception : :occurrence
    end
  end

  def notify?
    (@event.parent? && !high_frequency?) || notify_high_frequency? || occurrence_point?
  end

  def notifiable_status?
    !@event.muted? && !@event.parent&.muted?
  end

  def notification_point?(times_occurred)
    Constants::Event::OCCURRENCE_NOTIFICATION_POINTS.any? { |point| point == times_occurred }
  end

  def occurrence_point?
    notification_point?(@event.parent.occurrence_count) && !high_frequency?
  end

  def frequency
    @frequency ||= Event.since(1.minute.ago).where(title: @event.title, project_id: @event.project_id).count
  end

  def high_frequency?
    @high_frequency ||= frequency > Constants::Event::FIRST_NOTIFICATION_POINT - 1
  end

  def notify_high_frequency?
    notification_point?(frequency)
  end

  def notify_attributes
    return { event: @event, action: UserChannel::ACTIONS::CREATE_EVENT, reason: nil } if @event.parent?

    { event: @event.parent, action: UserChannel::ACTIONS::UPDATE_EVENT, reason: 'Occurrence' }
  end

  def user_emails
    @user_emails ||= event.project.users.pluck(:email)
  end
end
