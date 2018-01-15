# Notify user about changed forecast data
class NotifyUserJob < ApplicationJob
  queue_as :notifications

  def perform(user, spot_name, spot_url, new_matches, changed_matches, passed_matches)
    return unless new_matches.present? && user.notify_freq.include?(:initial_match, :every_change) \
                  || changed_matches.present? && user.notify_freq == :every_change \
                  || passed_matches.present? && user.passed_matches

    message = NotificationMailer.forecast_notification(user, spot_name, spot_url, new_matches,
                                                       changed_matches, passed_matches)
    # notify via mail
    message.deliver_later if user.mail_enabled

    # notify via Pushbullet
    return unless user.pb_enabled
    client = Washbullet::Client.new(user.pb_token)
    client.push_note(params: { title: message.subject, body: message.body.to_s })
  rescue Washbullet::Unauthorized
    Rails.logger.info "Invalid Pushbullet token for User: #{id}"
  end
end
