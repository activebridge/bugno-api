# frozen_string_literal: true

class Events::PositionUpdateService < ApplicationService
  def call
    Event.import(events.to_a, on_duplicate_key_update: [:position], validate: false)
  end

  private

  def order
    @column = 'COALESCE(last_occurrence_at, created_at)' if @column == 'created_at'
    "#{@column} #{@direction}".downcase
  end

  def events
    Event.where(project_id: @project_id, parent_id: nil, status: @status)
         .order(Arel.sql(order))
         .select(Arel.sql("id, ROW_NUMBER() OVER(ORDER BY #{order}) AS position"))
  end
end
