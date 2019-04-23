class AddRoleToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :role, :integer, default: 0
  end
end
