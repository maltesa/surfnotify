class AddIndexSpotToNotifications < ActiveRecord::Migration[5.1]
  def change
  end

  add_index :notifications, :spot
end
