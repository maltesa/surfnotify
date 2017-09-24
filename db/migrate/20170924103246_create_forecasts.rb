class CreateForecasts < ActiveRecord::Migration[5.1]
  def change
    create_table :forecasts do |t|
      t.integer :provider, default: 0
      t.string :spot
      t.json :forecast

      t.timestamps
    end

    add_index :forecasts, [:spot, :provider], unique: true
  end
end
