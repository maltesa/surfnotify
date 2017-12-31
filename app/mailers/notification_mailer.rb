class NotificationMailer < ApplicationMailer
  default from: 'notification@surfnotify.com'

  def forecast_notification(spot_name, spot, filtered_forecast, diff, user)
    @spot_name = spot_name
    @spot_url = spot
    @matching_dates = filtered_forecast.keys.map { |ts| parse_date(ts) }
    @diff_dates = diff.keys.map { |ts| parse_date(ts) }
    @user = user
    mail(to: @user.notification_mail, subject: "Forecast Notification for #{spot_name}")
  end

  def parse_date(ts)
    l(DateTime.strptime(ts, '%s'), format: :short)
  end
end
