class AddColumnsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :message, :string
    add_column :events, :backtrace, :text, array: true, default: []
    add_column :events, :framework, :string
    add_column :events, :url, :string
    add_column :events, :user_ip, :string
    add_column :events, :headers, :jsonb
    add_column :events, :method, :string
    add_column :events, :params, :jsonb
  end
end
