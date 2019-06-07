class ProjectSubscription < ActiveRecord::Migration[5.2]
  def change
    create_join_table :projects, :subscriptions do |t|
      t.index [:project_id, :subscription_id]
      t.index [:subscription_id, :project_id]
    end
  end
end
