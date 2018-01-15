class NotificationMailer < ApplicationMailer
  default from: 'notification@surfnotify.com'
  add_template_helper NotificationsHelper

  def forecast_notification(user, spot_name, spot_url, new_matches, changed_matches, passed_matches)
    @user = user
    @spot_name = spot_name
    @spot_url = spot_url
    @new_matches = new_matches
    @changed_matches = changed_matches
    @passed_matches = passed_matches
    subject_str = subject(spot_name, new_matches, changed_matches, passed_matches)
    mail(to: @user.notification_mail, subject: subject_str)
  end

  def subject(spot_name, new_matches, changed_matches, passed_matches)
    subject = "Forecast for #{spot_name} "
    verbs = []
    verbs << 'matches' if new_matches.present?
    verbs << 'has changed' if changed_matches.present?
    verbs << 'has lost matches' if passed_matches.present?
    subject << verbs.join(' and ')
  end
end
