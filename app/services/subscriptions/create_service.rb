# frozen_string_literal: true

class Subscriptions::CreateService < ApplicationService
  def call
    project.create_subscription(plan_id: params[:plan_id],
                                expires_at: 1.month.from_now,
                                events: plan_event_limit)
  end

  private

  def plan_event_limit
    @plan_event_limit ||= Plan.find(params[:plan_id]).event_limit
  end

  def project
    @project ||= Project.find(params[:project_id])
  end
end
