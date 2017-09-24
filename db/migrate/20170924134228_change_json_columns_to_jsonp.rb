class ChangeJsonColumnsToJsonp < ActiveRecord::Migration[5.1]
  def change
    change_column :notifications, :rules, :jsonb, default: {}, null: false
    change_column :forecasts, :forecast, :jsonb, default: [], null: false
  end
end
