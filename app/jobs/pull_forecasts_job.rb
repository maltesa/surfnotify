# enques PullForecastJobs which pull the forecast from MSW and subsequently start NotifyUserJobs
# which notifiy Users about changes to the forecast
# This Class is no child of ApplicationJob since application Job is not working with resque
# Scheduler
class PullForecastsJob
  # provider may be 'MagicSeaweed' etc.
  def self.perform(provider = nil)
    forecasts = provider.nil? ? Forecast.all : Forecast.where(provider: provider)
    # enque PullForecast Jobs
    forecasts.pluck(:id).each do |f_id|
      PullForecastJob.perform_later(f_id)
    end
  end
end
