# Pulls a forecast and notifies users of related notifications about changes in the data
# corresponding to their notification parameters
class PullForecastJob < ApplicationJob
  queue_as :data_collectors

  def perform(forecast_id)
    forecast = Forecast.find(forecast_id)
    return unless forecast.present?

    # TODO: select correct provider when multiple are implemented
    provider = MSW::Provider.new forecast.spot
    forecast.forecast = provider.pull
    forecast.save

    # update the related notifications (will enque notification jobs)
    forecast.notifications.each do |notification|
      notification.apply_rules_and_notify
      notification.save
    end
  end
end
