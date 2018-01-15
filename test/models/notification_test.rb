require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  test 'apply rules and notify' do
    # this notification belongs to one user and the rules will match its related forecast
    notification = notifications(:matching_notification)

    # make sure NotifyJob and MailJob are executed
    assert_performed_jobs 2 do
      # and mail was sent
      assert_emails 1 do
        notification.apply_rules_and_notify
      end
    end
  end

  test 'don notify if notification is silent' do
    # this notification belongs to one user and the rules will match its related forecast
    notification = notifications(:matching_notification)
    notification.silent = true

    # make sure job is executed, and mail is send
    assert_emails 0 do
      notification.apply_rules_and_notify
    end
  end
end
