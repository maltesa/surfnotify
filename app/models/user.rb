# Represents a User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable
  has_many :notifications
  validates :notification_mail, presence: true, if: -> () { mail_enabled }
  validates :pb_token, presence: true, if: -> () { pb_enabled }

  def notify(notification, diff)
    return unless diff.present?
    # TODO: more elegant solution to make diff serializable
    diff.each { |e| e[:time] = e[:time].to_s }
    NotificationMailer.notification(notification, diff, self).deliver_later if mail_enabled
    # TODO: send PB notification if pb_enabled
  end
end
