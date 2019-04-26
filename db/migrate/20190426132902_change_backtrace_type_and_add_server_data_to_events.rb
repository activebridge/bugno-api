class ChangeBacktraceTypeAndAddServerDataToEvents < ActiveRecord::Migration[5.2]
  def up
    execute "ALTER TABLE events
       ALTER COLUMN backtrace DROP DEFAULT,
       ALTER COLUMN backtrace TYPE Jsonb[] USING backtrace::Jsonb[];"
    change_column_default :events, :backtrace, []
    add_column :events, :server_data, :jsonb
  end

  def down
    execute "ALTER TABLE events
       ALTER COLUMN backtrace DROP DEFAULT,
       ALTER COLUMN backtrace TYPE TEXT[] USING backtrace::TEXT[];"
    change_column_default :events, :backtrace, []
    remove_column :events, :server_data
  end
end
