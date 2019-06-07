class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.date :expires_at
      t.integer :status, default: 0
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
