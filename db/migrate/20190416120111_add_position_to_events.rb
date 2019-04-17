class AddPositionToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :position, :integer
  end
end
