class AddNotificationSettingsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notify_freq, :integer, default: 0
    add_column :users, :notify_passed_matches, :boolean, default: true
  end
end
