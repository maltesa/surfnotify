# pull data for all forecasts and trigger notifications if necessary
class PullForecastsJob
  # provider may be 'MagicSeaweed' etc.
  def self.perform(provider = nil)
    forecasts = provider.nil? ? Forecast.all : Forecast.where(provider: provider)
    # pull each forecast and save the new data
    forecasts.each do |forecast|
      forecast.pull
      forecast.save
      # update the related notifications
      forecast.notifications.each do |notification|
        notification.apply_rules_and_notify
        notification.save
      end
    end
  end
end
