class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :name
      t.integer :provider, default: 0
      t.string :spot
      t.json :rules
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
