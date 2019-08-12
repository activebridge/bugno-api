class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :events, :parent_id
  end
end
