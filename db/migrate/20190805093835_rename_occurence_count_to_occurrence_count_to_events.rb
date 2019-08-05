class RenameOccurenceCountToOccurrenceCountToEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :occurence_count, :occurrence_count
  end
end
