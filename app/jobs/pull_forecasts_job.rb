# pull data for all forecasts and trigger notifications if necessary
class PullForecastsJob < ApplicationJob
  queue_as :default

  # provider may be 'MagicSeaweed' etc.
  def perform(provider = nil)
    forecasts = provider.nil? ? Forecast.all : Forecast.where(provider: provider)
    forecasts.each do |forecast|
      forecast.pull
      forecast.save
      forecast.notifications.each do |notification|
        notification.apply_rules_and_notify
        notification.save
      end
    end
  end
end
