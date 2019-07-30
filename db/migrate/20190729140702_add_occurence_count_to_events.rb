class AddOccurenceCountToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :occurence_count, :integer, default: 0
  end
end
