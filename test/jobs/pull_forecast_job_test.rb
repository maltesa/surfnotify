require 'test_helper'

class PullForecastJobTest < ActiveJob::TestCase
  test 'forecast is pulled' do
    # get forecast
    forecast = forecasts(:lagide)

    # perform pull job which may enqueue one notification job which may enqueue one mail job
    assert_performed_jobs 1, only: PullForecastJob do
      assert_nothing_raised do
        PullForecastJob.perform_later(forecast.id)
      end
    end

    # make sure the job has really updated the forecast
    assert (Time.now.to_i - Forecast.find(forecast.id).updated_at.to_time.to_i) < 5
  end
end
