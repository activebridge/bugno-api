class CreateIntegrations < ActiveRecord::Migration[5.2]
  def change
    create_table :integrations do |t|
      t.references :project, foreign_key: true, index: true
      t.string :type
      t.jsonb :provider_data

      t.timestamps
    end
  end
end
