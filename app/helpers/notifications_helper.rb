module NotificationsHelper
  def timestamp_to_fdate(ts)
    l(DateTime.strptime(ts, '%s'), format: :short)
  end
end
