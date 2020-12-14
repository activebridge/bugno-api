# frozen_string_literal: true

class Events::PositionUpdateService < ApplicationService
  def call
    Event.import(%i[id position], events, on_duplicate_key_update: [:position], validate: false)
  end

  private

  def order
    @column = 'COALESCE(last_occurrence_at, created_at)' if @column == 'created_at'
    "#{@column} #{@direction}".downcase
  end

  def events
    @project.events
            .where(parent_id: nil, status: @status)
            .order(Arel.sql(order))
            .pluck(Arel.sql("id, ROW_NUMBER() OVER(ORDER BY #{order}) - 1 AS position"))
  end
end
