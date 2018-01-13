class ChangeMailEnabledDefaultToTrueInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :mail_enabled, true
  end
end
