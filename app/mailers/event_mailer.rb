# frozen_string_literal: true

class EventMailer < ApplicationMailer
  def create(event)
    @event = event
    @users = event.project.users
    mail(to: @users.pluck(:email),
         subject: "[#{@event.project.name}] #{@event.environment}:\
         #{@event.title} has occured. #{@event.message.capitalize}")
  end
end
