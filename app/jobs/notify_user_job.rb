# Notify user about changed forecast data
class NotifyUserJob < ApplicationJob
  queue_as :notifications

  def perform(spot_name, spot, diff, user)
    return unless diff.present?
    message = NotificationMailer.forecast_notification(spot_name, spot, diff, user)

    # notify via mail
    message.deliver_later if user.mail_enabled

    # notify via Pushbullet
    return unless user.pb_enabled
    client = Washbullet::Client.new(pb_token)
    client.push_note(params: { title: message.subject, body: message.body.to_s })
  rescue Washbullet::Unauthorized
    Rails.logger.info "Invalid Pushbullet token for User: #{id}"
  end
end
