class AddSilentToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :silent, :boolean, default: false
  end
end
