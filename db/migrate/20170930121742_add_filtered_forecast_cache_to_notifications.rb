class AddFilteredForecastCacheToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :filtered_forecast_cache, :jsonb, default: [], null: false
  end
end
