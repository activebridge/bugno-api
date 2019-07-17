class AddRequestDataToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :person_data, :jsonb
    add_column :events, :route_params, :jsonb
  end
end
