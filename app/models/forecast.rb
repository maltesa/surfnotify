# handles stored forecasts
class Forecast < ApplicationRecord
  after_create :pull_and_notify
  has_many :notifications, primary_key: :spot, foreign_key: :spot

  # filter this forecast by given rules
  def filter_by(rules)
    # TODO: select correct provider when multiple exist
    constraints = MSW::Provider.rules2constraints(rules)
    MSW::Provider.filter_by(constraints, forecast)
  end

  # update forecast data and persist it from provider and notify users about updates
  def pull_and_notify
    PullForecastJob.perform_later(id)
  end

  # Immediately perform pull Job and persist forecast data
  def pull_and_notify!
    PullForecastJob.perform_now(id)
  end
end
