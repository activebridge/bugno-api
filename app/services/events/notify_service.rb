# frozen_string_literal: true

class Events::NotifyService < ApplicationService
  def call
    return unless notify?

    mailer = @event.parent? ? :exception : :occurrence
    EventMailer.send(mailer, @event, user_emails).deliver_later
    Integration.notify(notify_attributes)
  end

  private

  def notify?
    @event.parent? || occurrence_point?
  end

  def occurrence_point?
    Constants::Rules::OCCURRENCE_NOTIFICATION_POINTS.any? { |point| point == @event.parent&.occurrence_count }
  end

  def notify_attributes
    return { event: @event, action: UserChannel::ACTIONS::CREATE_EVENT, reason: nil } if @event.parent?

    { event: @event.parent, action: UserChannel::ACTIONS::UPDATE_EVENT, reason: 'Occurrence' }
  end

  def user_emails
    @user_emails ||= event.project.users.pluck(:email)
  end
end
