# Represents a User
class User < ApplicationRecord
  before_create :set_notification_mail
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :notifications
  validates :notification_mail, presence: true, if: -> () { mail_enabled }
  validates :pb_token, presence: true, if: -> () { pb_enabled }
  alias_attribute 'is_admin?', :admin

  def notify(spot_name, spot, diff)
    return unless diff.present?
    message = NotificationMailer.forecast_notification(spot_name, spot, diff, self)

    # notify via mail
    message.deliver_later if mail_enabled

    return unless pb_enabled
    # notify via Pushbullet
    client = Washbullet::Client.new(pb_token)
    client.push_note(params: { title: message.subject, body: message.body.to_s })
  rescue Washbullet::Unauthorized
    Rails.logger.info "Invalid Pushbullet token for User: #{id}"
  end

  def set_notification_mail
    write_attribute(:notification_mail, email)
  end
end
