class NotificationMailer < ApplicationMailer
  default from: 'notification@surfnotify.com'

  def notification(notification, diff, user)
    @notification = notification
    @dates = diff.map { |e| l(DateTime.parse(e[:time]), format: :short) }
    @user = user
    mail(to: @user.notification_mail, subject: 'Forecast Notification')
  end
end
