class AlterForecastsForecastDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :forecasts, :forecast, {}
  end
end
