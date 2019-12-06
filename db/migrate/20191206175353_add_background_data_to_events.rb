class AddBackgroundDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :background_data, :jsonb
  end
end
