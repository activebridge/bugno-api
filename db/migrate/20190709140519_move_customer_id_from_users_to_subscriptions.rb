class MoveCustomerIdFromUsersToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :customer_id, :string
    add_column :subscriptions, :customer_id, :string
  end
end
