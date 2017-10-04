class AddNotificationMethodsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification_mail, :string
    add_column :users, :mail_enabled, :boolean, default: false
    add_column :users, :pb_token, :string
    add_column :users, :pb_enabled, :boolean, default: false
  end
end
