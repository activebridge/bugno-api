class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :project, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.string :title
      t.string :environment
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
