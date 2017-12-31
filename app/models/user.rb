# Represents a User
class User < ApplicationRecord
  before_create :set_notification_mail
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :notifications
  validates :notification_mail, presence: true, if: -> () { mail_enabled }
  validates :pb_token, presence: true, if: -> () { pb_enabled }
  alias_attribute 'is_admin?', :admin

  def notify(spot_name, spot, filtered_forecast, diff)
    NotifyUserJob.perform_later(spot_name, spot, filtered_forecast, diff, self)
  end

  def set_notification_mail
    write_attribute(:notification_mail, email)
  end
end
