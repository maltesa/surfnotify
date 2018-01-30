# Represents a User
class User < ApplicationRecord
  before_validation :set_notification_mail, on: :create
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :notifications
  enum notify_freq: [:initial_match, :every_change]
  validates :notification_mail, presence: true, if: -> () { mail_enabled }
  validates :pb_token, presence: true, if: -> () { pb_enabled }
  alias_attribute 'is_admin?', :admin

  def notify(spot_name, spot_url, diff)
    # only notify if user settings allow this
    return unless
      diff.new_matches.present? && %w[initial_match every_change].include?(notify_freq) ||
      diff.changed_matches.present? && notify_freq == 'every_change' ||
      diff.passed_matches.present? && notify_passed_matches

    NotifyUserJob.perform_later(self, spot_name, spot_url,
                                diff.new_matches, diff.changed_matches, diff.passed_matches)
  end

  def set_notification_mail
    write_attribute(:notification_mail, email)
  end
end
