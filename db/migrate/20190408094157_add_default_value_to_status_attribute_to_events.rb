class AddDefaultValueToStatusAttributeToEvents < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:events, :status, 0)
  end
end
