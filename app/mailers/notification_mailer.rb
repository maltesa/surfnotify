class NotificationMailer < ApplicationMailer
  default from: 'notification@surfnotify.com'

  def forecast_notification(spot_name, spot, diff, user)
    @spot_name = spot_name
    @spot_url = spot
    @dates = diff.keys.map { |ts| l(DateTime.strptime(ts, '%s'), format: :short) }
    @user = user
    mail(to: @user.notification_mail, subject: 'Forecast Notification')
  end
end
