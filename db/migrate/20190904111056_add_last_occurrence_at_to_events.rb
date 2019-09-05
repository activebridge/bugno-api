class AddLastOccurrenceAtToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :last_occurrence_at, :datetime
  end
end
