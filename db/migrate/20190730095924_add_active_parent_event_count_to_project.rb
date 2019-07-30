class AddActiveParentEventCountToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :active_event_count, :integer, default: 0, null: false
  end
end
