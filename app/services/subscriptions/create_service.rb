# frozen_string_literal: true

class Subscriptions::CreateService < ApplicationService
  def call
    project.create_subscription(plan_id: params[:plan_id],
                                expires_at: 1.month.from_now)
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end
end
