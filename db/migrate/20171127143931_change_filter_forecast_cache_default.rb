class ChangeFilterForecastCacheDefault < ActiveRecord::Migration[5.1]
  def change
    change_column :notifications, :filtered_forecast_cache, :jsonb, default: {}, null: false
  end
end
