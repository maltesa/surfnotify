# Represents a User
class User < ApplicationRecord
  before_create :set_notification_mail
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :notifications
  enum notify_freq: [:initial_match, :every_change]
  validates :notification_mail, presence: true, if: -> () { mail_enabled }
  validates :pb_token, presence: true, if: -> () { pb_enabled }
  alias_attribute 'is_admin?', :admin

  def notify(spot_name, spot, diff)
    return if notify_freq == :initial_match && diff.new_matches? ||
              notify_freq == :every_change && diff.matches? ||
              notify_passed_matches && diff.passed_matches?
    NotifyUserJob.perform_later(self, spot_name, spot,
                                diff.new_matches, diff.changed_matches, diff.passed_matches)
  end

  def set_notification_mail
    write_attribute(:notification_mail, email)
  end
end
