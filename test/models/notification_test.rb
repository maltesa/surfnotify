require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  test 'apply rules and notify' do
    # this notification belongs to one user and the rules will match its related forecast
    notification = notifications(:matching_notification)

    # make sure job is executed, and mail is send
    assert_performed_jobs 2 do
      assert_emails 1 do
        notification.apply_rules_and_notify
      end
    end
  end
end
