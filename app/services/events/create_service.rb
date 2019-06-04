# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    EventMailer.create(event).deliver_later if project_by_api_key && event.persisted?
  end

  private

  def project_by_api_key
    @project_by_api_key ||= Project.find_by(api_key: params[:project_id])
  end

  def event
    @event ||= project_by_api_key.events.create(declared_params)
  end
end
