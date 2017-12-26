class AddSpotNameToForecast < ActiveRecord::Migration[5.1]
  def change
    add_column :forecasts, :spot_name, :string
  end
end
