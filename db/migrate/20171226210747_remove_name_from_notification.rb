class RemoveNameFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :name
  end
end
